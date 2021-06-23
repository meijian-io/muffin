import 'package:muffin/channel/navigator_channel.dart';

import 'data_model_change_listener.dart';

class Share {
  static Share instance = Share();

  late List<DataModelChangeListener> models;

  Future<void> init(List<DataModelChangeListener> models) async {
    this.models = models;

    for (var value in models) {
      Map<String, dynamic>? model =
          await NavigatorChannel.initDataModel(value.key());
      value.formJson(model!);
    }
  }

  Future<void> syncDataModel(Map<String, dynamic> map) async {
    for (var value in models) {
      if (value.key() == (map['key'] as String)) {
        value.formJson(map);
      }
    }
  }
}
