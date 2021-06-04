package com.meijian.muffin.navigator;

import android.app.Activity;

import java.lang.ref.WeakReference;
import java.util.LinkedList;

/**
 * Created by  on 2021/6/4.
 */
public class NavigatorStackManager {

  private NavigatorStackManager() {

  }

  private static NavigatorStackManager manager = new NavigatorStackManager();


  public static NavigatorStackManager getInstance() {
    return manager;
  }

  private LinkedList<NavigatorStack> stacks = new LinkedList<>();

  private LinkedList<WeakReference<Activity>> activityStacks = new LinkedList<>();

  public void push(NavigatorStack stack) {
    stacks.add(stack);
  }

  public void onActivityStart(Activity activity) {
    activityStacks.add(new WeakReference<>(activity));
  }

  public void onActivityDestroyed(Activity activity) {
    activityStacks.remove(new WeakReference<>(activity));
  }

}
