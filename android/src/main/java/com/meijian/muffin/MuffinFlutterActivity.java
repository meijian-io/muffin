package com.meijian.muffin;

import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;


import com.meijian.muffin.engine.EngineBinding;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

/**
 * Created by  on 2021/5/31.
 */
public class MuffinFlutterActivity extends FlutterActivity {

  public static final String PAGE_NAME = "pageName";
  public static final String ARGUMENTS = "arguments";

  private EngineBinding engineBinding;


  @Override protected void onCreate(@Nullable Bundle savedInstanceState) {
    if (!getIntent().hasExtra(PAGE_NAME)) {
      throw new RuntimeException("FlutterActivity mast has 'pageName'");
    }
    String pageName = getIntent().getStringExtra(PAGE_NAME);
    Map<String, Object> arguments = (Map<String, Object>) getIntent().getSerializableExtra(ARGUMENTS);
    if (arguments == null) {
      engineBinding = new EngineBinding(this, pageName);
    } else {
      engineBinding = new EngineBinding(this, pageName, arguments);
    }
    super.onCreate(savedInstanceState);
    //FlutterEngine attach, set method channel
    engineBinding.attach();
  }

  @Override protected void onDestroy() {
    super.onDestroy();
    //FlutterEngine detach ,clean method channel
    engineBinding.detach();
  }

  @Nullable @Override public FlutterEngine provideFlutterEngine(@NonNull Context context) {
    return engineBinding.getFlutterEngine();
  }

  public EngineBinding getEngineBinding() {
    return engineBinding;
  }
}
