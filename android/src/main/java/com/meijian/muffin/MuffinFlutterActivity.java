package com.meijian.muffin;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.meijian.muffin.engine.EngineBinding;
import com.meijian.muffin.engine.BindingProvider;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;

/**
 * Created by  on 2021/5/31.
 */
public class MuffinFlutterActivity extends FlutterActivity implements BindingProvider {

  public static final int REQUEST_CODE = 16;
  public static final int RESULT_CODE = 17;

  private EngineBinding engineBinding;


  @SuppressWarnings("unchecked") @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    if (getPageName() == null) {
      throw new RuntimeException("FlutterActivity mast has 'pageName'");
    }
    String pageName = getPageName();
    Map<String, Object> arguments = getArguments();
    if (arguments == null) {
      engineBinding = new EngineBinding(this, pageName);
    } else {
      engineBinding = new EngineBinding(this, pageName, arguments);
    }
    super.onCreate(savedInstanceState);
    //FlutterEngine attach, set method channel
    engineBinding.attach();
  }

  @Override public void onBackPressed() {
    provideEngineBinding().pop();
  }


  @Override protected void onDestroy() {
    super.onDestroy();
    //FlutterEngine detach ,clean method channel
    engineBinding.detach();
  }

  @Nullable @Override public FlutterEngine provideFlutterEngine(@NonNull Context context) {
    return engineBinding.getFlutterEngine();
  }

  @Override public EngineBinding provideEngineBinding() {
    return engineBinding;
  }

  @Override public void provideMethodChannel(BinaryMessenger messenger) {

  }

  @Override public String getPageName() {
    if (getIntent().hasExtra(PAGE_NAME)) {
      return getIntent().getStringExtra(PAGE_NAME);
    }
    return null;
  }

  @SuppressWarnings("unchecked") @Override public Map<String, Object> getArguments() {
    return (Map<String, Object>) getIntent().getSerializableExtra(ARGUMENTS);
  }
}
