package com.meijian.muffin;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.meijian.muffin.engine.EngineBinding;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

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
 *
 * MuffinFlutterFragment 导致flutter 返回键监听无法使用
 * 参考 BaseFlutterActivity 实现
 */
public class MuffinFlutterFragment extends FlutterFragment {

  public static final String PAGE_NAME = "pageName";
  public static final String ARGUMENTS = "arguments";
  public static final String URI = "uri";

  private EngineBinding engineBinding;


  @SuppressWarnings("unchecked") @Override public void onAttach(@NonNull Context context) {
    if (getArguments() == null) {
      return;
    }
    if (getArguments().getString(PAGE_NAME) == null && getArguments().getParcelable(URI) == null) {
      throw new RuntimeException("FlutterFragment mast has 'pageName' or 'Uri'");
    }
    if (getArguments().getParcelable(URI) != null) {
      engineBinding = new EngineBinding(getActivity(), (Uri) getArguments().getParcelable(URI));
    } else {
      String pageName = getArguments().getString(PAGE_NAME);
      Map<String, Object> arguments = (Map<String, Object>) getArguments().getSerializable(ARGUMENTS);
      if (arguments == null) {
        engineBinding = new EngineBinding(getActivity(), pageName);
      } else {
        engineBinding = new EngineBinding(getActivity(), pageName, arguments);
      }
    }
    //FlutterEngine attach, set method channel
    engineBinding.attach();
    super.onAttach(context);
  }

  public EngineBinding getEngineBinding() {
    return engineBinding;
  }

  @Nullable @Override public FlutterEngine provideFlutterEngine(@NonNull Context context) {
    return engineBinding.getFlutterEngine();
  }

  public static class MuffinFlutterFragmentBuilder extends FlutterFragment.NewEngineFragmentBuilder {

    private Uri initUri ;
    private String pageName = "/";
    private Map<String, Object> arguments = new HashMap<>();


    public MuffinFlutterFragmentBuilder(@NonNull Class<? extends FlutterFragment> subclass) {
      super(subclass);
    }

    public MuffinFlutterFragmentBuilder setInitUri(Uri initUri) {
      this.initUri = initUri;
      return this;
    }

    public MuffinFlutterFragmentBuilder setPageName(String pageName) {
      this.pageName = pageName;
      return this;
    }

    public MuffinFlutterFragmentBuilder setArguments(Map<String, Object> arguments) {
      this.arguments = arguments;
      return this;
    }

    @NonNull @Override protected Bundle createArgs() {
      Bundle bundle = super.createArgs();
      bundle.putParcelable(URI, this.initUri);
      bundle.putString(PAGE_NAME, this.pageName);
      bundle.putSerializable(ARGUMENTS, (Serializable) this.arguments);
      return bundle;
    }
  }
}
