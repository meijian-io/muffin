package com.meijian.muffin;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.text.TextUtils;


import com.meijian.muffin.engine.EngineGroupCache;
import com.meijian.muffin.navigator.DefaultPushFlutterHandler;
import com.meijian.muffin.navigator.NavigatorStackManager;
import com.meijian.muffin.navigator.PushFlutterHandler;
import com.meijian.muffin.navigator.PushNativeHandler;
import com.meijian.muffin.sharing.DataModelChangeListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.engine.FlutterEngineGroup;

/**
 * Created by  on 2021/5/31.
 */
public class Muffin {

  private static Muffin muffin;

  private EngineGroupCache engineGroup;

  private List<DataModelChangeListener> models;

  private PushNativeHandler nativeHandler;

  private PushFlutterHandler flutterHandler;

  public static Muffin getInstance() {
    if (muffin == null) {
      muffin = new Muffin();
    }
    return muffin;
  }


  public void init(Application context, List<DataModelChangeListener> dataModels, PushNativeHandler handler) {
    engineGroup = new EngineGroupCache(context, new FlutterEngineGroup(context));
    context.registerActivityLifecycleCallbacks(new MuffinAppLifecycle());
    this.models = dataModels;
    this.nativeHandler = handler;
    this.flutterHandler = new DefaultPushFlutterHandler();
  }

  public void init(Application context, PushNativeHandler handler) {
    engineGroup = new EngineGroupCache(context, new FlutterEngineGroup(context));
    context.registerActivityLifecycleCallbacks(new MuffinAppLifecycle());
    this.nativeHandler = handler;
    this.flutterHandler = new DefaultPushFlutterHandler();
  }

  public void init(Application context, List<DataModelChangeListener> dataModels, PushNativeHandler handler, PushFlutterHandler flutterHandler) {
    engineGroup = new EngineGroupCache(context, new FlutterEngineGroup(context));
    context.registerActivityLifecycleCallbacks(new MuffinAppLifecycle());
    this.models = dataModels;
    this.nativeHandler = handler;
    this.flutterHandler = flutterHandler;
  }

  public EngineGroupCache getEngineGroup() {
    return engineGroup;
  }


  public List<DataModelChangeListener> getModels() {
    if (models == null) {
      return new ArrayList<>();
    }
    return models;
  }

  public HashMap<String, Object> getDataModelByKey(String key) {
    for (DataModelChangeListener model : models) {
      if (TextUtils.equals(model.key(), key)) {
        return model.toMap();
      }
    }
    return new HashMap<>();
  }

  public PushNativeHandler getNativeHandler() {
    return nativeHandler;
  }

  public PushFlutterHandler getFlutterHandler() {
    return flutterHandler;
  }

  static class MuffinAppLifecycle implements Application.ActivityLifecycleCallbacks {

    @Override public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
      NavigatorStackManager.getInstance().onActivityCreate(activity);
    }

    @Override public void onActivityStarted(Activity activity) {
    }

    @Override public void onActivityResumed(Activity activity) {

    }

    @Override public void onActivityPaused(Activity activity) {

    }

    @Override public void onActivityStopped(Activity activity) {

    }

    @Override public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

    }

    @Override public void onActivityDestroyed(Activity activity) {
      NavigatorStackManager.getInstance().onActivityDestroyed(activity);
    }
  }
}
