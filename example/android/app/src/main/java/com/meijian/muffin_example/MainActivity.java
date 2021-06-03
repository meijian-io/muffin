package com.meijian.muffin_example;

import android.app.Activity;
import android.os.Bundle;


import androidx.annotation.Nullable;

import com.meijian.muffin.navigator.MuffinNavigator;

import java.util.HashMap;
import java.util.Map;


public class MainActivity extends Activity {

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
}
