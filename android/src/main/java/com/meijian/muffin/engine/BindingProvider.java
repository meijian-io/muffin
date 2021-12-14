package com.meijian.muffin.engine;

import android.net.Uri;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Created by  on 2021/6/29.
 */
public interface BindingProvider {

  String PAGE_NAME = "pageName";
  String ARGUMENTS = "arguments";
  String URI = "uri";

  EngineBinding provideEngineBinding();

  void provideMethodChannel(BinaryMessenger messenger);

  String getPageName();

  Map<String, Object> getArguments();
}
