package com.meijian.muffin.navigator;

import android.content.Context;
import android.content.Intent;

import com.meijian.muffin.MuffinFlutterActivity;

import java.io.Serializable;
import java.util.Map;

/**
 * 原生路由
 * <p>
 * Created by  on 2021/5/31.
 */
public class MuffinNavigator {

  public static void push(Context context, String pageName) {
    Intent intent = new Intent(context, MuffinFlutterActivity.class);
    intent.putExtra(MuffinFlutterActivity.PAGE_NAME, pageName);
    context.startActivity(intent);
  }

  public static void push(Context context, String pageName, FlutterResult result) {
    //这里的context为 activity，这这些栈保存起来。
  }

  public static void push(Context context, String pageName, Map<String, Object> arguments) {
    Intent intent = new Intent(context, MuffinFlutterActivity.class);
    intent.putExtra(MuffinFlutterActivity.PAGE_NAME, pageName);
    intent.putExtra(MuffinFlutterActivity.ARGUMENTS, (Serializable) arguments);
    context.startActivity(intent);
  }

  public static void push(Context context, String pageName, Map<String, Object> arguments, FlutterResult result) {

  }

}
