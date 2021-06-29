package com.meijian.muffin_example;

import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;

import com.meijian.muffin.MuffinFlutterFragment;
import com.meijian.muffin.engine.EngineBinding;
import com.meijian.muffin.engine.EngineBindingProvider;

/**
 * Created by  on 2021/6/29.
 */
public class BaseFlutterActivity extends FragmentActivity implements EngineBindingProvider {

  private MuffinFlutterFragment flutterFragment;

  @Override protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.flutter_fragment_page);

    flutterFragment = new MuffinFlutterFragment.MuffinFlutterFragmentBuilder(MuffinFlutterFragment.class)
        .setPageName("/home").build();

    getSupportFragmentManager()
        .beginTransaction()
        .replace(R.id.container, flutterFragment).commitAllowingStateLoss();
  }

  @Override public EngineBinding provideEngineBinding() {
    return flutterFragment.getEngineBinding();
  }

  @Override public void onBackPressed() {
    provideEngineBinding().pop();
  }
}
