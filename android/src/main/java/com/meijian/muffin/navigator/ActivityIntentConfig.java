package com.meijian.muffin.navigator;

import android.app.Activity;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by  on 2021/6/7.
 */
public class ActivityIntentConfig {

  /**
   * flutter to native, startActivity
   */
  Class<? extends Activity> activityClazz;

  /**
   * intent build
   */
  List<String> arguments = new ArrayList<>();

  public ActivityIntentConfig(Class<? extends Activity> activityClazz) {
    this.activityClazz = activityClazz;
  }

  public ActivityIntentConfig(Class<? extends Activity> activityClazz, List<String> arguments) {
    this.activityClazz = activityClazz;
    this.arguments = arguments;
  }
}
