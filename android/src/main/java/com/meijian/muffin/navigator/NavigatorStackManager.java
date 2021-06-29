package com.meijian.muffin.navigator;

import android.app.Activity;
import android.text.TextUtils;

import com.meijian.muffin.Logger;
import com.meijian.muffin.Muffin;
import com.meijian.muffin.engine.BindingProvider;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by  on 2021/6/4.
 */
public class NavigatorStackManager {

  private static final String TAG = NavigatorStackManager.class.getSimpleName();

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


  public void syncFlutterStack(NavigatorStack stack) {
    stacks.addFirst(stack);
    Logger.log(TAG, "flutter has pushed ,size = " + stacks.size());
    logStack();
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
        NavigatorStack temp = stacks
            .getFirst();
        if (TextUtils.equals(temp.getPageName(), target)) {
          targetStack = temp;
          findTarget = true;
        } else {
          NavigatorStack popped = stacks.removeFirst();
          shouldPoppedStacks.add(popped);
        }
      } else {
        findTarget = true;
      }
    }

    if (targetStack == null) {
      Logger.log(TAG, "target not found ,size = " + stacks.size());
      logStack();
      return;
    }
    if (shouldPoppedStacks.isEmpty()) {
      Logger.log(TAG, "no stack to pop ,size = " + stacks.size());
      logStack();
      return;
    }
    //2. if all should removed stacks are flutter , return
    boolean allInFlutterStack = true;
    for (NavigatorStack shouldPoppedStack : shouldPoppedStacks) {
      if (shouldPoppedStack.getHost().hashCode() != targetStack.getHost().hashCode()) {
        allInFlutterStack = false;
        break;
      }
    }
    if (allInFlutterStack) {
      Logger.log(TAG, "only flutter pop, pop finish ,size = " + stacks.size());
      logStack();
      return;
    }
    //3. add removed flutter stack , then flutter will continue pop
    for (int i = shouldPoppedStacks.size() - 1; i >= 0; i--) {
      if (shouldPoppedStacks.get(i).getHost().hashCode() == targetStack.getHost().hashCode()) {
        stacks.addFirst(shouldPoppedStacks.get(i));
      }
    }
    //4.finish top vc
    for (NavigatorStack poppedStack : shouldPoppedStacks) {
      if (poppedStack.getHost().hashCode() == targetStack.getHost().hashCode()) {
        continue;
      }
      poppedStack.setResult(result, target);
      poppedStack.getHost().finish();
    }

    //5. has popped to targetVC ,notifyCallbacks
    if (!(targetStack.getHost() instanceof BindingProvider)) {
      targetStack.notifyCallbacks(result, target);
      Logger.log(TAG, "popUntil native finish ,size = " + stacks.size());
      logStack();
      return;
    }
    Logger.log(TAG, "has flutter stacks  to pop ,size = " + stacks.size());
    logStack();
    //6. continue flutter pop
    ((BindingProvider) targetStack.getHost()).provideEngineBinding().popUntil(target, result);
  }

  /**
   * 给外侧跳转
   *
   * @param pageName pageName
   * @param data arguments
   * @return find
   */
  @SuppressWarnings("unchecked") public boolean pushNamed(String pageName, Object data) {
    HashMap<String, Object> arguments = new HashMap<>();
    if (data instanceof HashMap) {
      arguments = (HashMap<String, Object>) data;
    }
    Muffin.getInstance().getNativeHandler().pushNamed(getTopActivity(), pageName, arguments);
    return true;
  }


  public void onActivityCreate(Activity activity) {
    //only add native activity, flutter pages has already added to stack
    if (!(activity instanceof BindingProvider)) {
      stacks.addFirst(new NavigatorStack(activity, activity.getClass().getSimpleName()));
      Logger.log(TAG, "stack add, size = " + stacks.size());
      logStack();
    }
  }

  public void onActivityDestroyed(Activity activity) {
    //all stacks has already removed
    //only for handling system backPressed
    if (!(activity instanceof BindingProvider)) {
      //check if has popped
      Iterator<NavigatorStack> iterator = stacks.iterator();
      while (iterator.hasNext()) {
        NavigatorStack stack = iterator.next();
        if (stack.getHost().hashCode() == activity.hashCode()) {
          iterator.remove();
          Logger.log(TAG, "stack remove, system back press, size = " + stacks.size());
          logStack();
        }
      }
    }
  }


  public Activity getTopActivity() {
    return stacks.getFirst().getHost();
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

  public String findPopTarget() {
    if (stacks.size() > 1) {
      return stacks.get(1).getPageName();
    }
    return "/";
  }

  private void logStack() {
    if (stacks.isEmpty()) {
      return;
    }
    for (NavigatorStack stack : stacks) {
      Logger.log(TAG, stack.toString());
    }
  }
}
