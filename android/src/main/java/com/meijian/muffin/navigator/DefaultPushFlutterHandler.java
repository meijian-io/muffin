package com.meijian.muffin.navigator;

import android.net.Uri;
import android.text.TextUtils;

import java.util.HashMap;

/**
 * Created by  on 2021/6/24.
 */
public class DefaultPushFlutterHandler implements PushFlutterHandler {
  @Override public String getPath(Uri uri) {
    return "/" + uri.getQueryParameter("url");
  }

  @Override public HashMap<String, Object> getArguments(Uri uri) {
    HashMap<String, Object> arguments = new HashMap<>();
    for (String queryParameterName : uri.getQueryParameterNames()) {
      if (!TextUtils.equals("url", queryParameterName)) {
        arguments.put(queryParameterName, uri.getQueryParameter(queryParameterName));
      }
    }
    return arguments;
  }
}
