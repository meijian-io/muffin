package com.meijian.muffin_example;

import android.app.Application;
import android.content.Intent;
import android.text.TextUtils;


import com.meijian.muffin.Muffin;
import com.meijian.muffin.sharing.DataModelChangeListener;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by  on 2021/5/31.
 */
public class App extends Application {

  @Override public void onCreate() {
    super.onCreate();
    List<DataModelChangeListener> models = new ArrayList<>();
    models.add(BasicInfo.getInstance());

    Muffin.getInstance().init(this, models, (activity, pageName, data) -> {
      //根据 pageName 和 data 拼接成 schema 跳转
      if (TextUtils.equals("/main", pageName)) {
        Intent intent = new Intent(activity, MainActivity.class);
        activity.startActivity(intent);
      }
    });
  }
}
