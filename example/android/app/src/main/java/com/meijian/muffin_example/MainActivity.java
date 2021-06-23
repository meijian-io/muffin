package com.meijian.muffin_example;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;


import androidx.annotation.Nullable;

import com.meijian.muffin.navigator.MuffinNavigator;
import com.meijian.muffin.navigator.PathProvider;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;


public class MainActivity extends Activity implements PathProvider {

  @Override protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    findViewById(R.id.main).setOnClickListener(view -> MuffinNavigator.push(MainActivity.this, "/home"));

    findViewById(R.id.first).setOnClickListener(view -> {
      Map<String, Object> arguments = new HashMap<>();
      arguments.put("count", 1);
      arguments.put("desc", "This is cool");
      arguments.put("good", true);
      MuffinNavigator.push(MainActivity.this, "/first", arguments);
    });

    findViewById(R.id.second).setOnClickListener(view -> {
      //MuffinNavigator.push(MainActivity.this, "second")
      startActivity(new Intent(MainActivity.this, SecondActivity.class));
    });

    findViewById(R.id.change_basic_info).setOnClickListener(view -> {
          new Thread(new Runnable() {
            @Override public void run() {
              while (true) {
                try {
                  runOnUiThread(new Runnable() {
                    @Override public void run() {
                      BasicInfo.getInstance().setUserId("newUserId" + new Random().nextInt());
                    }
                  });
                  Thread.sleep(5000);
                } catch (InterruptedException e) {
                  e.printStackTrace();
                }
              }
            }
          }).start();
        }

    );
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

  @Override protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
  }
}
