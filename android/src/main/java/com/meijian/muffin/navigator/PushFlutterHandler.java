package com.meijian.muffin.navigator;

import android.net.Uri;

import java.util.HashMap;

/**
 * Created by  on 2021/6/24.
 */
public interface PushFlutterHandler {

  String getPath(Uri uri);

  HashMap<String, Object> getArguments(Uri uri);
}
