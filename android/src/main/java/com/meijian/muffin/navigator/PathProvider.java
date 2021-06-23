package com.meijian.muffin.navigator;

import android.content.Context;

import java.util.HashMap;

/**
 * Created by  on 2021/6/4.
 */
@Deprecated
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


  void onFlutterActivityResult(String pageName, HashMap<String, Object> result);
}
