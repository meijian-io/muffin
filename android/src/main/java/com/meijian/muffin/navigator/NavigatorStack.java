package com.meijian.muffin.navigator;

import android.app.Activity;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by  on 2021/6/4.
 * <p>
 * 管理所有路由栈
 * N1         F1      F1      N2
 * /native1   /home   /first  /native2
 * <p>
 * question: Native 页面的 path 如何定义，ARouter ？
 */
public class NavigatorStack {

  /**
   * 宿主activity的hashCode，用来处理返回值
   */
  private WeakReference<Activity> host;
  /**
   * 页面标示 path
   */
  private String pageName;

  /**
   * 事件回调
   */
  List<FlutterResult> callbacks = new ArrayList<>();

  public NavigatorStack(PathProvider provider, FlutterResult callback) {
    this.host = new WeakReference<>((Activity) provider.getContext());
    this.pageName = provider.getPath();
    callbacks.add(callback);
  }


  public NavigatorStack(PathProvider provider) {
    this.host = new WeakReference<>((Activity) provider.getContext());
    this.pageName = provider.getPath();
  }
}
