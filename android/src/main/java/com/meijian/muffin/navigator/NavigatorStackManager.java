package com.meijian.muffin.navigator;

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


  public void push(NavigatorStack stack) {
    stacks.add(stack);
  }

}
