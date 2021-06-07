package com.meijian.muffin.navigator;

import android.content.Context;

/**
 * Created by  on 2021/6/4.
 */
public interface PathProvider {

  /**
   * Activity 实现此接口，返回配置的path
   *
   * @return /path
   */
  String getPath();

  /**
   * Context，用于跳转
   *
   * @return Activity
   */
  Context getContext();
}
