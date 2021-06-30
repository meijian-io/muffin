package com.meijian.muffin_example;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;


import androidx.annotation.Nullable;

import com.meijian.muffin.navigator.MuffinNavigator;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;


public class MainActivity extends Activity {

  @Override protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    findViewById(R.id.main).setOnClickListener(view -> MuffinNavigator.push("/home"));

    findViewById(R.id.first).setOnClickListener(view -> {
      Map<String, Object> arguments = new HashMap<>();
      arguments.put("count", 1);
      arguments.put("desc", "This is cool");
      arguments.put("good", true);
      MuffinNavigator.push("/first", arguments);
    });

    findViewById(R.id.second).setOnClickListener(view -> {
      MuffinNavigator.pushForResult(Uri.parse("meijianclient://meijian.io?url=first&name=uri_test"));
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

    findViewById(R.id.open_with_fragment).setOnClickListener(v ->
        MuffinNavigator.pushForResult("/home"));
  }

  @Override protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (data != null) {
      Log.e("AAA", data.getStringExtra("pageName"));
      Log.e("AAA", (data.getSerializableExtra("result")).toString());
    }
  }
}
