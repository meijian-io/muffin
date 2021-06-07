package com.meijian.muffin.navigator;

import android.app.Activity;

import com.meijian.muffin.Logger;
import com.meijian.muffin.MuffinFlutterActivity;
import com.meijian.muffin.utils.WrappedWeakReference;

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

  /**
   * real stack, contains native and flutters
   * N1 F(1) F(2) N2
   * size = 4
   */
  private LinkedList<NavigatorStack> stacks = new LinkedList<>();

  /**
   * native activity stack,
   * N1 F(1) F(2) N2
   * four pages but three activity size  = 3
   */
  private LinkedList<WrappedWeakReference<Activity>> originActivityStacks = new LinkedList<>();

  public void push(NavigatorStack stack) {
    stacks.add(0, stack);
    Logger.log("stacks", "flutter has pushed ,size = " + stacks.size());
  }

  public void pop(NavigatorStack stack) {
    stacks.remove(stack);
    Logger.log("stacks", "flutter has popped ,size = " + stacks.size());
  }


  public void onActivityCreate(Activity activity) {
    originActivityStacks.add(0, new WrappedWeakReference<>(activity));
    Logger.log("originActivityStacks", "size = " + originActivityStacks.size());
    //only add native activity, flutter pages has already added to stack
    if (activity instanceof PathProvider && !(activity instanceof MuffinFlutterActivity)) {
      stacks.add(new NavigatorStack((PathProvider) activity));
      Logger.log("stacks", "size = " + stacks.size());
    }
  }

  public void onActivityDestroyed(Activity activity) {
    originActivityStacks.remove(new WrappedWeakReference<>(activity));
    Logger.log("originActivityStacks", "size = " + originActivityStacks.size());
    //only remove native activity, flutter pages has already removed
    if (activity instanceof PathProvider && !(activity instanceof MuffinFlutterActivity)) {
      stacks.remove(new NavigatorStack((PathProvider) activity));
      Logger.log("stacks", "size = " + stacks.size());
    }
  }

}
