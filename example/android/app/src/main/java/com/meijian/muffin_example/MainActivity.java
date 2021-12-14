package com.meijian.muffin_example;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.meijian.muffin.Muffin;
import com.meijian.muffin.navigator.MuffinNavigator;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;


public class MainActivity extends Activity {

  @Override protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    TextView textView = findViewById(R.id.text);
    textView.setText(textView.getText() + "\n 当前模式： " + Muffin.getInstance().getAttachVc().getSimpleName());

    findViewById(R.id.home).setOnClickListener(view -> MuffinNavigator.push("/home"));

    findViewById(R.id.home_result).setOnClickListener(view -> MuffinNavigator.pushForResult("/home", 100));


    findViewById(R.id.first).setOnClickListener(view -> {
      Map<String, Object> arguments = new HashMap<>();
      arguments.put("count", 1);
      arguments.put("desc", "This is cool");
      arguments.put("good", true);
      MuffinNavigator.push("/home/first", arguments);
    });

    findViewById(R.id.first_result).setOnClickListener(view -> {
      Map<String, Object> arguments = new HashMap<>();
      arguments.put("count", 1);
      arguments.put("desc", "This is cool");
      arguments.put("good", true);
      MuffinNavigator.pushForResult("/home/first", arguments, 101);
    });

    findViewById(R.id.open_with_uri).setOnClickListener(view -> {
      MuffinNavigator.push(Uri.parse("meijianclient://meijian.io?url=/home/first&name=uri_test"));
    });

    findViewById(R.id.open_with_uri_result).setOnClickListener(view -> {
      MuffinNavigator.pushForResult(Uri.parse("meijianclient://meijian.io?url=/home/second/111&name=uri_test"));
    });

    findViewById(R.id.not_found).setOnClickListener(v -> MuffinNavigator.push("/hoome"));

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

  @Override protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (data != null) {
      Log.e("AAA", "requestCode : " + requestCode + "; resultCode : " + resultCode);
      String result = (data.getSerializableExtra("result")).toString();
      Toast.makeText(this, result, Toast.LENGTH_SHORT).show();
      Log.e("AAA", result);
    }
  }
}
