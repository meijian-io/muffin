package com.meijian.muffin.navigator;

import android.content.Context;

/**
 * Created by  on 2021/6/4.
 */
public interface PathProvider {

  /**
   * Activity 实现此接口，返回配置的path
   * 若是接入ARouter，获取配置的path，可能性分析
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
