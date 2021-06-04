package com.meijian.muffin.navigator;

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

  public static void push(PathProvider provider, String pageName) {
    //maybe first push a flutter page
    NavigatorStackManager.getInstance().push(new NavigatorStack(provider));

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
