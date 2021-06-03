package com.meijian.muffin.navigator;

import java.util.Map;

/**
 * Created by  on 2021/5/31.
 * Flutter关闭时回调
 */
public interface FlutterResult {
  /**
   * Native打开Flutter页面，携带返回值
   *
   * @param result Map
   */
  void onResult(Map<String, Object> result);
}
