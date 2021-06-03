package com.meijian.muffin;

import android.app.Application;


import com.meijian.muffin.engine.EngineGroupCache;

import io.flutter.embedding.engine.FlutterEngineGroup;

/**
 * Created by  on 2021/5/31.
 */
public class Muffin {

  private static Muffin muffin;

  private EngineGroupCache engineGroup;


  public static Muffin getInstance() {
    if (muffin == null) {
      muffin = new Muffin();
    }
    return muffin;
  }


  public void init(Application context) {
    engineGroup = new EngineGroupCache(context, new FlutterEngineGroup(context));
  }


  public EngineGroupCache getEngineGroup() {
    return engineGroup;
  }
}
