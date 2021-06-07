package com.meijian.muffin_example;

import android.app.Application;

import com.meijian.muffin.Muffin;
import com.meijian.muffin.navigator.ActivityIntentConfig;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by  on 2021/5/31.
 */
public class App extends Application {

  @Override public void onCreate() {
    super.onCreate();
    //use a router?
    List<ActivityIntentConfig> intentConfigs = new ArrayList<>();
    intentConfigs.add(new ActivityIntentConfig(MainActivity.class));

    Muffin.getInstance().init(this, intentConfigs);
  }
}
