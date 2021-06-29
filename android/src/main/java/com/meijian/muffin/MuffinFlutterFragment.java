package com.meijian.muffin;

import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.engine.FlutterEngine;

/**
 * Created by  on 2021/6/29.
 * <p>
 * 使用场景：
 * 当Flutter页面需要调用所在Activity的一些能力
 * 这些能力一般来自于原生CommonActivity, 那么所打开的Activity必须继承CommonActivity而不能继承 MuffinFlutterActivity
 * 那么就可能需要使用到 MuffinFlutterFragment，导致的冲突就是 NavigatorStack host 为 [Activity] 而不是[Fragment]
 * 从而给框架带来影响
 */
public class MuffinFlutterFragment extends FlutterFragment {

  @Override public void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
  }

  @Nullable @Override public FlutterEngine provideFlutterEngine(@NonNull Context context) {
    return super.provideFlutterEngine(context);
  }
}
