package com.meijian.muffin.navigator;

import android.app.Activity;
import android.text.TextUtils;

import com.meijian.muffin.Logger;
import com.meijian.muffin.MuffinFlutterActivity;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

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


  public void push(NavigatorStack stack) {
    stacks.addFirst(stack);
    Logger.log("stacks", "flutter has pushed ,size = " + stacks.size());
  }

  /**
   * find target stack remove base on pageName
   *
   * @param target the path of target  NavigatorStack
   * @param result pop result
   */

  public void pop(String target, Object result) {
    popUntil(target, result);
  }

  /**
   * find target stack remove base on pageName, remove top NavigatorStacks and Activity
   *
   * @param target the path of target  NavigatorStack
   * @param result pop result
   */
  public void popUntil(String target, Object result) {
    //1. find target NavigatorStack, and tap needs to remove NavigatorStack
    List<NavigatorStack> shouldPoppedStacks = new ArrayList<>();
    NavigatorStack targetStack = null;
    boolean findTarget = false;
    while (!findTarget) {
      if (!stacks.isEmpty()) {
        NavigatorStack temp = stacks.getFirst();
        if (TextUtils.equals(temp.getPageName(), target)) {
          targetStack = temp;
          findTarget = true;
        } else {
          NavigatorStack popped = stacks.removeFirst();
          popped.setHasPopped(true);
          shouldPoppedStacks.add(popped);
        }
      } else {
        findTarget = true;
      }
    }

    if (targetStack == null) {
      return;
    }
    if (shouldPoppedStacks.isEmpty()) {
      return;
    }
    //2. add removed flutter stack , then flutter will continue pop
    for (int i = shouldPoppedStacks.size() - 1; i >= 0; i--) {
      if (shouldPoppedStacks.get(i).getHost().hashCode() == targetStack.getHost().hashCode()) {
        stacks.addFirst(shouldPoppedStacks.get(i));
      }
    }
    //3.finish vc
    for (NavigatorStack poppedStack : shouldPoppedStacks) {
      if (poppedStack.getHost().hashCode() == targetStack.getHost().hashCode()) {
        continue;
      }
      poppedStack.getHost().finish();
    }

    //4. continue pop
    if (targetStack.getHost() instanceof PathProvider) {
      return;
    }
    ((MuffinFlutterActivity) targetStack.getHost()).getEngineBinding().popUntil(target, result);
  }


  public void onActivityCreate(Activity activity) {
    //only add native activity, flutter pages has already added to stack
    if (activity instanceof PathProvider && !(activity instanceof MuffinFlutterActivity)) {
      stacks.addFirst(new NavigatorStack((PathProvider) activity));
      Logger.log("stacks", "size = " + stacks.size());
    }
  }

  public void onActivityDestroyed(Activity activity) {
    //all stacks has already removed
    //only for handling system backPressed
    if (activity instanceof PathProvider && !(activity instanceof MuffinFlutterActivity)) {
      //check if has popped
      NavigatorStack currentTopNavigatorStack = stacks.getFirst();
      if (currentTopNavigatorStack.getHost().hashCode() == activity.hashCode()) {
        stacks.removeFirst();
      }
    }
  }


  public NavigatorStack findTargetNavigatorStack(String pageName) {
    NavigatorStack targetStack = null;
    for (NavigatorStack navigatorStack : stacks) {
      if (TextUtils.equals(navigatorStack.getPageName(), pageName)) {
        targetStack = navigatorStack;
        break;
      }
    }
    return targetStack;
  }

}
