package com.meijian.muffin.engine;

import android.app.Application;
import android.content.Context;
import android.text.TextUtils;

import androidx.collection.LruCache;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineGroup;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.loader.FlutterLoader;

/**
 * Created by  on 2021/5/31.
 * 查看实现源码{@link FlutterEngineGroup}
 * 主要是FlutterJNI的nativeSpawn方法
 * 我们这里使用 Map缓存FlutterEngine，也没有必要每次都重新生成
 */
public class EngineGroupCache {

  //TODO cache
  //private LruCache<String, FlutterEngine> flutterEngines = new LruCache<>(5);

  private FlutterEngineGroup engineGroup;

  public EngineGroupCache(Application context, FlutterEngineGroup engineGroup) {
    this.engineGroup = engineGroup;
    createAndRunEngine(context, "main");
  }

  public FlutterEngine createAndRunEngine(Context context, String pageName) {
    if (TextUtils.isEmpty(pageName)) {
      pageName = "main";
    }
    FlutterLoader flutterLoader = FlutterInjector.instance().flutterLoader();
    return engineGroup.createAndRunEngine(context,
        new DartExecutor.DartEntrypoint(flutterLoader.findAppBundlePath(), pageName));
  }

}
