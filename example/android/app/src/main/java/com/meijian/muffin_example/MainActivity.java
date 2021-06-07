package com.meijian.muffin_example;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;


import androidx.annotation.Nullable;

import com.meijian.muffin.navigator.FlutterResult;
import com.meijian.muffin.navigator.MuffinNavigator;
import com.meijian.muffin.navigator.PathProvider;

import java.util.HashMap;
import java.util.Map;


public class MainActivity extends Activity implements PathProvider {

  @Override protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    findViewById(R.id.main).setOnClickListener(view -> MuffinNavigator.push(MainActivity.this, "main"));

    findViewById(R.id.first).setOnClickListener(view -> {
      Map<String, Object> arguments = new HashMap<>();
      arguments.put("count", 1);
      arguments.put("desc", "This is cool");
      arguments.put("good", true);
      MuffinNavigator.push(MainActivity.this, "first", arguments);
    });

    findViewById(R.id.second).setOnClickListener(view -> MuffinNavigator.push(MainActivity.this, "second"));
  }

  @Override public String getPath() {
    return "/native_main";
  }

  @Override public Context getContext() {
    return MainActivity.this;
  }

  @Override public void onFlutterActivityResult(String pageName, HashMap<String, Object> result) {
    Log.e("AAA", (String) result.get("data"));
  }
}
