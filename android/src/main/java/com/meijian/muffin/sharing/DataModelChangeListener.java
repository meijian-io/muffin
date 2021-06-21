package com.meijian.muffin.sharing;

import java.beans.PropertyChangeListener;
import java.util.HashMap;

/**
 * Created by  on 2021/6/21.
 * 数据共享 数据变化监听者
 */
public interface DataModelChangeListener {

  void addPropertyChangeListener(PropertyChangeListener changeListener);

  void removePropertyChangeListener(PropertyChangeListener changeListener);

  HashMap<String, Object> toMap();

}
