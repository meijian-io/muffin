package com.meijian.muffin_example;

import com.meijian.muffin.sharing.DataModelChangeListener;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.util.HashMap;

/**
 * Created by  on 2021/6/21.
 */
public class BasicInfo implements DataModelChangeListener {

  private static final BasicInfo instance = new BasicInfo();

  public static BasicInfo getInstance() {
    return instance;
  }

  private String userId;
  private boolean isBindTbk;

  private BasicInfo() {
    userId = getUserId();
    isBindTbk = isBindTbk();
  }

  private PropertyChangeSupport propertyChangeSupport = new PropertyChangeSupport(this);


  @Override public String key() {
    return "BasicInfo";
  }

  @Override public void addPropertyChangeListener(PropertyChangeListener changeListener) {
    propertyChangeSupport.addPropertyChangeListener(changeListener);
  }

  @Override public void removePropertyChangeListener(PropertyChangeListener changeListener) {
    propertyChangeSupport.removePropertyChangeListener(changeListener);
  }

  @Override public HashMap<String, Object> toMap() {
    HashMap<String, Object> map = new HashMap<>();
    map.put("key", key());
    map.put("userId", userId);
    map.put("isBindTbk", isBindTbk);
    return map;
  }

  @Override public void formJson(HashMap<String, Object> map) {
    setUserId((String) map.get("userId"));
    setBindTbk((Boolean) map.get("isBindTbk"));
  }

  public String getUserId() {
    //TODO 换成XXXUtils
    return "userId";
  }

  public void setUserId(String userId) {
    String old = this.userId;
    this.userId = userId;
    propertyChangeSupport.firePropertyChange("userId", old, userId);
  }

  public boolean isBindTbk() {
    //TODO 换成XXXUtils
    return false;
  }

  public void setBindTbk(boolean bindTbk) {
    boolean old = this.isBindTbk;
    isBindTbk = bindTbk;
    propertyChangeSupport.firePropertyChange("isBindTbk", old, bindTbk);
  }
}
