package com.meijian.muffin_example;

import android.app.Application;

import com.meijian.muffin.Muffin;

/**
 * Created by  on 2021/5/31.
 */
public class App extends Application {

  @Override public void onCreate() {
    super.onCreate();
    Muffin.getInstance().init(this);
  }
}
