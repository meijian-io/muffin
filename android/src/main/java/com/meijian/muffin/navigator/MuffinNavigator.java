package com.meijian.muffin.navigator;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import com.meijian.muffin.Muffin;
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

  public static void push(String pageName) {
    Activity context = NavigatorStackManager.getInstance().getTopActivity();
    Intent intent = new Intent(context, Muffin.getInstance().getAttachVc());
    intent.putExtra(MuffinFlutterActivity.PAGE_NAME, pageName);
    context.startActivity(intent);
    //while flutter has pushed, then add a new NavigatorStack to NavigatorStackManager
  }

  public static void pushForResult(String pageName) {
    Activity context = NavigatorStackManager.getInstance().getTopActivity();
    Intent intent = new Intent(context, Muffin.getInstance().getAttachVc());
    intent.putExtra(MuffinFlutterActivity.PAGE_NAME, pageName);
    context.startActivityForResult(intent, MuffinFlutterActivity.REQUEST_CODE);
    //while flutter has pushed, then add a new NavigatorStack to NavigatorStackManager
  }

  public static void pushForResult(String pageName, int requestCode) {
    Activity context = NavigatorStackManager.getInstance().getTopActivity();
    Intent intent = new Intent(context, Muffin.getInstance().getAttachVc());
    intent.putExtra(MuffinFlutterActivity.PAGE_NAME, pageName);
    context.startActivityForResult(intent, requestCode);
    //while flutter has pushed, then add a new NavigatorStack to NavigatorStackManager
  }

  public static void pushForResult(String pageName, Map<String, Object> arguments) {
    Activity context = NavigatorStackManager.getInstance().getTopActivity();
    Intent intent = new Intent(context, Muffin.getInstance().getAttachVc());
    intent.putExtra(MuffinFlutterActivity.PAGE_NAME, pageName);
    intent.putExtra(MuffinFlutterActivity.ARGUMENTS, (Serializable) arguments);
    context.startActivityForResult(intent, MuffinFlutterActivity.REQUEST_CODE);
  }

  public static void pushForResult(String pageName, Map<String, Object> arguments, int requestCode) {
    Activity context = NavigatorStackManager.getInstance().getTopActivity();
    Intent intent = new Intent(context, Muffin.getInstance().getAttachVc());
    intent.putExtra(MuffinFlutterActivity.PAGE_NAME, pageName);
    intent.putExtra(MuffinFlutterActivity.ARGUMENTS, (Serializable) arguments);
    context.startActivityForResult(intent, requestCode);
  }

  public static void push(String pageName, Map<String, Object> arguments) {
    Activity context = NavigatorStackManager.getInstance().getTopActivity();
    Intent intent = new Intent(context, Muffin.getInstance().getAttachVc());
    intent.putExtra(MuffinFlutterActivity.PAGE_NAME, pageName);
    intent.putExtra(MuffinFlutterActivity.ARGUMENTS, (Serializable) arguments);
    context.startActivity(intent);
  }

  public static void push(Uri uri) {
    Activity context = NavigatorStackManager.getInstance().getTopActivity();
    Intent intent = new Intent(context, Muffin.getInstance().getAttachVc());
    intent.putExtra(MuffinFlutterActivity.URI, uri);
    context.startActivity(intent);
  }


  public static void pushForResult(Uri uri) {
    Activity context = NavigatorStackManager.getInstance().getTopActivity();
    Intent intent = new Intent(context, Muffin.getInstance().getAttachVc());
    intent.putExtra(MuffinFlutterActivity.URI, uri);
    context.startActivityForResult(intent, MuffinFlutterActivity.REQUEST_CODE);
  }

  public static void pushForResult(Uri uri, int requestCode) {
    Activity context = NavigatorStackManager.getInstance().getTopActivity();
    Intent intent = new Intent(context, Muffin.getInstance().getAttachVc());
    intent.putExtra(MuffinFlutterActivity.URI, uri);
    context.startActivityForResult(intent, requestCode);
  }

}
