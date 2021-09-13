package com.meijian.muffin.navigator;

import android.app.Activity;

import androidx.annotation.NonNull;

import java.util.HashMap;

/**
 * Created by  on 2021/6/23.
 */
public interface PushNativeHandler {

  void pushNamed(Activity activity, String pageName, @NonNull HashMap<String, Object> data);
}
