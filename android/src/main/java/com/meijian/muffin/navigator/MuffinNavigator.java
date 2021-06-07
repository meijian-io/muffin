package com.meijian.muffin.navigator;

import android.content.Intent;

import com.meijian.muffin.MuffinFlutterActivity;

import java.io.Serializable;
import java.util.Map;

/**
 * 原生路由
 * <p>
 * Created by  on 2021/5/31.
 * <p>
 * native to flutter
 * 1. 直接调用 MuffinNavigator 方法
 * 2. 通过 ARouter schema
 * <p>
 * flutter to native
 * 1.直接调用 MuffinNavigator 方法。 到原生之后，拼接成 ARouter schema 跳转
 */
public class MuffinNavigator {

  public static void push(PathProvider provider, String pageName) {
    Intent intent = new Intent(provider.getContext(), MuffinFlutterActivity.class);
    intent.putExtra(MuffinFlutterActivity.PAGE_NAME, pageName);
    provider.getContext().startActivity(intent);
    //while flutter has pushed, then add a new NavigatorStack to NavigatorStackManager
  }

  public static void push(PathProvider provider, String pageName, FlutterResult result) {
    //这里的context为 activity，这这些栈保存起来。
  }

  public static void push(PathProvider provider, String pageName, Map<String, Object> arguments) {
    Intent intent = new Intent(provider.getContext(), MuffinFlutterActivity.class);
    intent.putExtra(MuffinFlutterActivity.PAGE_NAME, pageName);
    intent.putExtra(MuffinFlutterActivity.ARGUMENTS, (Serializable) arguments);
    provider.getContext().startActivity(intent);
  }

  public static void push(PathProvider provider, String pageName, Map<String, Object> arguments, FlutterResult result) {

  }

}
