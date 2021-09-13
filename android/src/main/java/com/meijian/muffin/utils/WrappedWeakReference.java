package com.meijian.muffin.utils;

import androidx.annotation.Nullable;

import java.lang.ref.WeakReference;

/**
 * Created by  on 2021/6/7.
 */
public class WrappedWeakReference<T> extends WeakReference<T> {

  T t;

  public WrappedWeakReference(T t) {
    super(t);
  }


  @Override public boolean equals(@Nullable Object obj) {
    if (obj == null) {
      return false;
    }
    return get().hashCode() == ((WrappedWeakReference) obj).get().hashCode();
  }
}
