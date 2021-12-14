package com.meijian.muffin_example;

import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;

import com.meijian.muffin.MuffinFlutterFragment;
import com.meijian.muffin.engine.EngineBinding;
import com.meijian.muffin.engine.BindingProvider;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

/**
 * Created by  on 2021/6/29.
 */
public class BaseFlutterActivity extends FragmentActivity implements BindingProvider {

  private MuffinFlutterFragment flutterFragment;

  private MethodChannel customChannel;

  @Override protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.flutter_fragment_page);

    flutterFragment = new MuffinFlutterFragment.MuffinFlutterFragmentBuilder(MuffinFlutterFragment.class)
        .setPageName(getPageName()).setArguments(getArguments()).build();

    getSupportFragmentManager()
        .beginTransaction()
        .replace(R.id.container, flutterFragment).commitAllowingStateLoss();
  }

  @Override public EngineBinding provideEngineBinding() {
    return flutterFragment.getEngineBinding();
  }

  @Override public void provideMethodChannel(BinaryMessenger messenger) {
    //destory
    customChannel = new MethodChannel(messenger, "custom_channel");
    customChannel.setMethodCallHandler((call, result) -> {

    });
  }

  @Override public void onBackPressed() {
    if (flutterFragment != null) {
      flutterFragment.onBackPressed();
    }
  }

  @Override protected void onDestroy() {
    if (customChannel != null) {
      customChannel.setMethodCallHandler(null);
    }
    super.onDestroy();
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
