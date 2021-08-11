import 'dart:async';
import 'package:muffin/sharing/share.dart';
import 'package:muffin/sharing/data_model_change_listener.dart';

typedef ChannelMock = dynamic Function (String key,dynamic value);

class Muffin {
  static Muffin instance = Muffin();

  late ChannelMock onMockFunc;

  Future<void> initShare(List<DataModelChangeListener> models) async {
    Share.instance.init(models);
  }
}
