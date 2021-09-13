package com.meijian.muffin_example;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;

import androidx.annotation.Nullable;

import com.meijian.muffin.navigator.MuffinNavigator;
import com.meijian.muffin.navigator.PathProvider;

import java.util.HashMap;

/**
 * Created by  on 2021/6/10.
 */
public class SecondActivity extends Activity implements PathProvider {

  @Override protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_second);

    findViewById(R.id.first).setOnClickListener(v -> MuffinNavigator.push("main"));
  }

  @Override public String getPath() {
    return "/native_second";
  }

  @Override public Context getContext() {
    return this;
  }

  @Override public void onFlutterActivityResult(String pageName, HashMap<String, Object> result) {

  }
}
