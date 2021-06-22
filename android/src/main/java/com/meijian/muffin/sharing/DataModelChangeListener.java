package com.meijian.muffin.sharing;

import java.beans.PropertyChangeListener;
import java.util.HashMap;

/**
 * Created by  on 2021/6/21.
 * 数据共享 数据变化监听者
 */
public interface DataModelChangeListener {

  /**
   * 存在多个共享类时，需要标记一下，在需要同步时按照key查找到该对象
   *
   * @return key
   */
  String key();

  void addPropertyChangeListener(PropertyChangeListener changeListener);

  void removePropertyChangeListener(PropertyChangeListener changeListener);

  HashMap<String, Object> toMap();

}
