package com.meijian.muffin;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;


import com.meijian.muffin.engine.EngineGroupCache;
import com.meijian.muffin.navigator.ActivityIntentConfig;
import com.meijian.muffin.navigator.NavigatorStackManager;
import com.meijian.muffin.sharing.DataModelChangeListener;

import java.util.List;

import io.flutter.embedding.engine.FlutterEngineGroup;

/**
 * Created by  on 2021/5/31.
 */
public class Muffin {

  private static Muffin muffin;

  private EngineGroupCache engineGroup;

  private List<ActivityIntentConfig> intentConfigs;

  private List<DataModelChangeListener> models;

  public static Muffin getInstance() {
    if (muffin == null) {
      muffin = new Muffin();
    }
    return muffin;
  }


  public void init(Application context, List<ActivityIntentConfig> intentConfigs, List<DataModelChangeListener> dataModels) {
    engineGroup = new EngineGroupCache(context, new FlutterEngineGroup(context));
    context.registerActivityLifecycleCallbacks(new MuffinAppLifecycle());
    this.intentConfigs = intentConfigs;
    this.models = dataModels;
  }


  public EngineGroupCache getEngineGroup() {
    return engineGroup;
  }

  public List<ActivityIntentConfig> getIntentConfigs() {
    return intentConfigs;
  }

  public List<DataModelChangeListener> getModels() {
    return models;
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
