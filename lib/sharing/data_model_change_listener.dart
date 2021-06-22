import 'package:flutter/material.dart';
import 'package:muffin/channel/navigator_channel.dart';

abstract class DataModelChangeListener extends ChangeNotifier {
  Map<String, Object> toMap();

  String key();

  void formJson(Map<String, dynamic> map);

  @override
  void notifyListeners() {
    super.notifyListeners();
    NavigatorChannel.syncDataModel(toMap());
  }
}
