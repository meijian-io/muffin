package com.meijian.muffin;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.meijian.muffin.engine.EngineBinding;
import com.meijian.muffin.engine.EngineBindingProvider;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;

/**
 * Created by  on 2021/5/31.
 */
public class MuffinFlutterActivity extends FlutterActivity implements EngineBindingProvider {

  public static final int REQUEST_CODE = 16;
  public static final int RESULT_CODE = 17;

  public static final String PAGE_NAME = "pageName";
  public static final String ARGUMENTS = "arguments";
  public static final String URI = "uri";

  private EngineBinding engineBinding;


  @SuppressWarnings("unchecked") @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    if (getUri() == null && getPageName() == null) {
      throw new RuntimeException("FlutterActivity mast has 'pageName' or 'Uri'");
    }
    if (getUri() != null) {
      engineBinding = new EngineBinding(this, getUri());
    } else {
      String pageName = getPageName();
      Map<String, Object> arguments = getArguments();
      if (arguments == null) {
        engineBinding = new EngineBinding(this, pageName);
      } else {
        engineBinding = new EngineBinding(this, pageName, arguments);
      }
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

  @Override public EngineBinding provideEngineBinding() {
    return engineBinding;
  }

  @Override public void provideMethodChannel(BinaryMessenger messenger) {

  }

  @Override public Uri getUri() {
    if (getIntent().hasExtra(URI)) {
      return (Uri) getIntent().getParcelableExtra(URI);
    }
    return null;
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
