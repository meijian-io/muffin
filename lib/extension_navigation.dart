import 'package:muffin/core/muffin_interface.dart';
import 'package:muffin/sharing/data_model_change_listener.dart';
import 'package:muffin/sharing/share.dart';

import 'core/mock.dart';

extension MuffinNavigation on MuffinInterface {
  void push() {}
}

///配置类的一些方法接口
extension MuffinConfig on MuffinInterface {
  void addMock(MockConfig config) {
    mockConfig.add(config);
  }

  void addMocks(List<MockConfig> configs) {
    mockConfig.addAll(configs);
  }

  get onMockFunc => (key, value) {
        return mockConfig
            .firstWhere((element) => (element.key == key),
                orElse: () => MockConfig(key, (key, value) => {}))
            .mock(key, value);
      };

  Future<void> initShare(List<DataModelChangeListener> models) async {
    await Share.instance.init(models);
  }
}
