package com.meijian.muffin.engine;

import android.app.Activity;
import android.net.Uri;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.meijian.muffin.Logger;
import com.meijian.muffin.Muffin;
import com.meijian.muffin.navigator.NavigatorStack;
import com.meijian.muffin.navigator.NavigatorStackManager;
import com.meijian.muffin.sharing.DataModelChangeListener;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Created by  on 2021/5/31.
 * 提供 Engine和 MethodChannel ，open flutter page and send arguments to Flutter
 */
public class EngineBinding implements PropertyChangeListener {
  private static final String TAG = EngineBinding.class.getSimpleName();
  private FlutterEngine flutterEngine;
  private MethodChannel methodChannel;

  public EngineBinding(Activity context, String pageName) {
    this(context, pageName, null);
  }

  public EngineBinding(Activity context, Uri uri) {
    this(context,
        Muffin.getInstance().getFlutterHandler().getPath(uri),
        Muffin.getInstance().getFlutterHandler().getArguments(uri));
  }

  public EngineBinding(final Activity context, final String pageName, final Map<String, Object> arguments) {
    flutterEngine = Muffin.getInstance().getEngineGroup().createAndRunEngine(context, "main");
    methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "muffin_navigate");
    methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
          //Flutter 获取值
          case "getArguments": {
            Map<String, Object> map = new HashMap<>();
            map.put("url", pageName);
            map.put("arguments", arguments == null ? new HashMap<String, Object>() : arguments);
            result.success(map);
          }
          break;
          //flutter has pushed, sync stack
          case "syncFlutterStack": {
            NavigatorStackManager.getInstance().syncFlutterStack(
                new NavigatorStack(context, (String) call.argument("pageName")));
            result.success(new HashMap<>());
          }
          break;
          case "pop": {
            NavigatorStackManager.getInstance().pop(
                (String) call.argument("pageName"), call.argument("result"));
            result.success(new HashMap<>());
          }
          break;
          case "popUntil": {
            NavigatorStackManager.getInstance().popUntil(
                (String) call.argument("pageName"), call.argument("result"));
            result.success(new HashMap<>());
          }
          break;
          case "findPopTarget": {
            String target = NavigatorStackManager.getInstance().findPopTarget();
            result.success(target);
          }
          break;
          case "pushNamed": {
            boolean find = NavigatorStackManager.getInstance().pushNamed(
                (String) call.argument("pageName"), call.argument("data"));
            result.success(find);
          }
          break;
          //Flutter 返回值
          case "setArguments":
            break;

          case "initDataModel":
            String key = call.argument("key");
            result.success(Muffin.getInstance().getDataModelByKey(key));
            break;
          case "syncDataModel":
            HashMap<String, Object> model = call.arguments();
            for (DataModelChangeListener listener : Muffin.getInstance().getModels()) {
              if (TextUtils.equals((String) model.get("key"), listener.key())) {
                Logger.log(TAG, "flutter change mode , native sync :" + model.toString());
                listener.formJson(model);
              }
            }
            result.success(new HashMap<>());
            break;
          default:
            result.notImplemented();
        }
      }
    });
  }


  public void attach() {
    for (DataModelChangeListener model : Muffin.getInstance().getModels()) {
      model.addPropertyChangeListener(this);
    }
  }


  public void detach() {
    if (flutterEngine != null) {
      //activeEngines in FlutterEngineGroup will call [onEngineWillDestroy]
      flutterEngine.destroy();
    }
    if (methodChannel != null) {
      methodChannel.setMethodCallHandler(null);
    }
    for (DataModelChangeListener model : Muffin.getInstance().getModels()) {
      model.removePropertyChangeListener(this);
    }
  }

  public void popUntil(String pageName, Object result) {
    Map<String, Object> map = new HashMap<>();
    map.put("pageName", pageName);
    map.put("result", result);
    methodChannel.invokeMethod("popUntil", map);
  }


  public FlutterEngine getFlutterEngine() {
    return flutterEngine;
  }

  @Override public void propertyChange(PropertyChangeEvent evt) {
    Logger.log(TAG, "propertyChange");
    Object source = evt.getSource();
    if (source instanceof DataModelChangeListener) {
      Logger.log(TAG, "value changed -- " + ((DataModelChangeListener) source).toMap().toString());
      methodChannel.invokeMethod("syncDataModel", ((DataModelChangeListener) source).toMap());
    }
  }
}
