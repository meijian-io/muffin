package com.meijian.muffin.navigator;

import android.app.Activity;

import java.lang.ref.WeakReference;

/**
 * Created by  on 2021/6/1.
 */
public class RouteSettings {
  /**
   * 宿主activity的hashCode，用来处理返回值
   */
  private WeakReference<Activity> host;
  /**
   * 页面标示，Native vc 取 vc hashCode to String
   */
  private String pageName;

}
