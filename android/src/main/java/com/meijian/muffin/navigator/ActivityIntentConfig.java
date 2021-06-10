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
  private Class<? extends Activity> activityClazz;

  /**
   * intent build
   */
  private List<String> arguments = new ArrayList<>();

  private String path;

  public ActivityIntentConfig(Class<? extends Activity> activityClazz, String path) {
    this.activityClazz = activityClazz;
    this.path = path;
  }

  public ActivityIntentConfig(Class<? extends Activity> activityClazz, List<String> arguments, String path) {
    this.activityClazz = activityClazz;
    this.arguments = arguments;
    this.path = path;
  }

  public String getPath() {
    return path;
  }

  public void setPath(String path) {
    this.path = path;
  }

  public Class<? extends Activity> getActivityClazz() {
    return activityClazz;
  }
}
