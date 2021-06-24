package com.meijian.muffin.utils;

import android.net.Uri;
import android.text.TextUtils;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by  on 2021/6/23.
 */
public class SchemeUtils {

  private static final String host = "meijianclient://meijian.io?";

  public static String getUrl(String pageName) {
    return Uri.parse(host).buildUpon().appendQueryParameter("url", pageName).build().toString();
  }

  public static String getUrl(String pageName, Map<String, Object> arguments) {

    Uri.Builder uriBuilder = Uri.parse(host).buildUpon();
    uriBuilder.appendQueryParameter("url", pageName);

    for (Map.Entry<String, Object> entry : arguments.entrySet()) {
      uriBuilder.appendQueryParameter(entry.getKey(), entry.getValue().toString());
    }
    return uriBuilder.build().toString();
  }

  public static String getPath(Uri uri) {
    return "/" + uri.getQueryParameter("url");
  }

  public static Map<String, Object> getParams(Uri uri) {
    Map<String, Object> arguments = new HashMap<>();
    for (String queryParameterName : uri.getQueryParameterNames()) {
      if (!TextUtils.equals("url", queryParameterName)) {
        arguments.put(queryParameterName, uri.getQueryParameter(queryParameterName));
      }
    }
    return arguments;
  }
}
