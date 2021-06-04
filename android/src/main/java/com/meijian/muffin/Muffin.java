package com.meijian.muffin;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;


import com.meijian.muffin.engine.EngineGroupCache;
import com.meijian.muffin.navigator.NavigatorStackManager;

import io.flutter.embedding.engine.FlutterEngineGroup;

/**
 * Created by  on 2021/5/31.
 */
public class Muffin {

  private static Muffin muffin;

  private EngineGroupCache engineGroup;


  public static Muffin getInstance() {
    if (muffin == null) {
      muffin = new Muffin();
    }
    return muffin;
  }


  public void init(Application context) {
    engineGroup = new EngineGroupCache(context, new FlutterEngineGroup(context));
    context.registerActivityLifecycleCallbacks(new MuffinAppLifecycle());
  }


  public EngineGroupCache getEngineGroup() {
    return engineGroup;
  }

  static class MuffinAppLifecycle implements Application.ActivityLifecycleCallbacks {

    @Override public void onActivityCreated(Activity activity, Bundle savedInstanceState) {

    }

    @Override public void onActivityStarted(Activity activity) {
      NavigatorStackManager.getInstance().onActivityStart(activity);
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
