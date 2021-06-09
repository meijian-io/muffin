package com.meijian.muffin.navigator;

import android.app.Activity;
import android.text.TextUtils;

import java.lang.ref.WeakReference;
import java.util.HashMap;
import java.util.Map;

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

  private PathProvider pathProvider;


  public NavigatorStack(PathProvider provider) {
    this.host = new WeakReference<>((Activity) provider.getContext());
    this.pageName = provider.getPath();
    this.pathProvider = provider;
  }

  public NavigatorStack(Activity activity, String pageName) {
    this.host = new WeakReference<>(activity);
    this.pageName = pageName;
  }


  @Override public boolean equals(Object o) {
    NavigatorStack that = (NavigatorStack) o;
    return TextUtils.equals(that.pageName, that.pageName);
  }

  public PathProvider getPathProvider() {
    return pathProvider;
  }

  public String getPageName() {
    return pageName;
  }

  public void notifyCallbacks(Object result, String pageName) {
    if (pathProvider != null && result instanceof HashMap) {
      pathProvider.onFlutterActivityResult(pageName, (HashMap<String, Object>) result);
    }
  }
}
