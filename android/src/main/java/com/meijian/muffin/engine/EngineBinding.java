package com.meijian.muffin.engine;

import android.app.Activity;

import androidx.annotation.NonNull;


import com.meijian.muffin.Muffin;
import com.meijian.muffin.navigator.NavigatorStack;
import com.meijian.muffin.navigator.NavigatorStackManager;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Created by  on 2021/5/31.
 * 提供 Engine和 MethodChannel ，open flutter page and send arguments to Flutter
 */
public class EngineBinding {

  private FlutterEngine flutterEngine;
  private MethodChannel methodChannel;

  public EngineBinding(Activity context, String entryPoint) {
    this(context, entryPoint, null);
  }

  public EngineBinding(final Activity context, String entryPoint, final Map<String, Object> arguments) {
    flutterEngine = Muffin.getInstance().getEngineGroup().createAndRunEngine(context, entryPoint);
    methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "muffin_navigate");
    methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
          //Flutter 获取值
          case "getArguments":
            if (arguments != null) {
              result.success(arguments);
            } else {
              result.success(new HashMap<String, Object>());
            }
            break;
          //flutter has pushed, async stack
          case "push":
            NavigatorStackManager.getInstance().push(
                new NavigatorStack(context, (String) call.argument("pageName")));
            result.success(new HashMap<>());
            break;
          case "pop":
            NavigatorStackManager.getInstance().pop(
                new NavigatorStack(context, (String) call.argument("pageName")));
            result.success(new HashMap<>());
            break;
          //Flutter 返回值
          case "setArguments":
            break;
          default:
            result.notImplemented();
        }
      }
    });
  }

  public void attach() {

  }

  public void detach() {
    methodChannel.setMethodCallHandler(null);
  }

  public FlutterEngine getFlutterEngine() {
    return flutterEngine;
  }
}
