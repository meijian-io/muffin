package com.meijian.muffin;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.text.TextUtils;


import androidx.annotation.NonNull;

import com.meijian.muffin.engine.BindingProvider;
import com.meijian.muffin.engine.EngineGroupCache;
import com.meijian.muffin.navigator.DefaultPushFlutterHandler;
import com.meijian.muffin.navigator.NavigatorStackManager;
import com.meijian.muffin.navigator.PushFlutterHandler;
import com.meijian.muffin.navigator.PushNativeHandler;
import com.meijian.muffin.sharing.DataModelChangeListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.engine.FlutterEngineGroup;

/**
 * Created by  on 2021/5/31.
 */
public class Muffin {

  private static Muffin muffin;

  private EngineGroupCache engineGroup;

  private List<DataModelChangeListener> models;

  private PushNativeHandler nativeHandler;

  private PushFlutterHandler flutterHandler;

  private Class<? extends BindingProvider> attachVc;


  public static Muffin getInstance() {
    if (muffin == null) {
      throw new RuntimeException("Must call Muffin init");
    }
    return muffin;
  }

  public Muffin(List<DataModelChangeListener> dataModels, PushNativeHandler handler,
      PushFlutterHandler flutterHandler,
      Class<? extends BindingProvider> attachVc) {
    this.models = dataModels;
    this.nativeHandler = handler;
    this.flutterHandler = flutterHandler == null ? new DefaultPushFlutterHandler() : flutterHandler;
    this.attachVc = attachVc;
  }

  public static void init(Application context, Options options) {
    muffin = new Muffin(options.models, options.nativeHandler, options.flutterHandler, options.attachVc);
    muffin.init(context);
  }


  public void init(Application context) {
    engineGroup = new EngineGroupCache(context, new FlutterEngineGroup(context));
    context.registerActivityLifecycleCallbacks(new MuffinAppLifecycle());
  }

  public EngineGroupCache getEngineGroup() {
    return engineGroup;
  }


  public List<DataModelChangeListener> getModels() {
    if (models == null) {
      models = new ArrayList<>();
    }
    return models;
  }

  public Class<? extends BindingProvider> getAttachVc() {
    return attachVc;
  }

  /**
   * late add
   *
   * @param models [DataModelChangeListener]
   */
  public void addChangeableModels(List<DataModelChangeListener> models) {
    getModels().addAll(models);
  }

  public HashMap<String, Object> getDataModelByKey(String key) {
    for (DataModelChangeListener model : models) {
      if (TextUtils.equals(model.key(), key)) {
        return model.toMap();
      }
    }
    return new HashMap<>();
  }

  public PushNativeHandler getNativeHandler() {
    return nativeHandler;
  }

  public PushFlutterHandler getFlutterHandler() {
    return flutterHandler;
  }

  public static class Options {

    private List<DataModelChangeListener> models;

    private PushNativeHandler nativeHandler;

    private PushFlutterHandler flutterHandler;

    private Class<? extends BindingProvider> attachVc = MuffinFlutterActivity.class;

    public Options setModels(@NonNull List<DataModelChangeListener> models) {
      this.models = models;
      return this;
    }

    /**
     * Flutter -> Native
     *
     * @param nativeHandler PushNativeHandler
     * @return Options
     */
    public Options setPushNativeHandler(@NonNull PushNativeHandler nativeHandler) {
      this.nativeHandler = nativeHandler;
      return this;
    }

    /**
     * Native -> Flutter
     *
     * @param flutterHandler PushFlutterHandler
     * @return Options
     */
    public Options setPushFlutterHandler(@NonNull PushFlutterHandler flutterHandler) {
      this.flutterHandler = flutterHandler;
      return this;
    }

    public Options setAttachVc(Class<? extends BindingProvider> attachVc) {
      this.attachVc = attachVc;
      return this;
    }
  }

  static class MuffinAppLifecycle implements Application.ActivityLifecycleCallbacks {

    @Override public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
      NavigatorStackManager.getInstance().onActivityCreate(activity);
    }

    @Override public void onActivityStarted(Activity activity) {
    }

    @Override public void onActivityResumed(Activity activity) {

    }

    @Override public void onActivityPaused(Activity activity) {

    }

    @Override public void onActivityStopped(Activity activity) {

    }

    @Override public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

    }

    @Override public void onActivityDestroyed(Activity activity) {
      NavigatorStackManager.getInstance().onActivityDestroyed(activity);
    }
  }
}
