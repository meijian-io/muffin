import 'dart:async';
import 'package:muffin/sharing/share.dart';
import 'package:muffin/sharing/data_model_change_listener.dart';

typedef Mock = dynamic Function(String key, dynamic value);

class MockConfig {
  final String key;
  final Mock mock;

  MockConfig(this.key, this.mock);
}

class Muffin {
  static Muffin instance = Muffin();

  Muffin() {
    mockConfig.add(MockConfig('getArguments', (key, value) => {'url': '/'}));
    mockConfig.add(MockConfig('syncFlutterStack', (key, value) => {}));
    mockConfig.add(MockConfig('pushNamed', (key, value) => false));
    mockConfig.add(MockConfig('findPopTarget', (key, value) => ''));
    mockConfig.add(MockConfig('popUntil', (key, value) => {}));
    mockConfig.add(MockConfig('initDataModel', (key, value) => {}));
  }

  List<MockConfig> mockConfig = [];

  get onMockFunc => (key, value) {
        return mockConfig
            .firstWhere((element) => (element.key == key),
                orElse: () => MockConfig(key, (key, value) => {}))
            .mock(key, value);
      };

  void addMock(MockConfig config) {
    mockConfig.add(config);
  }

  void addMocks(List<MockConfig> configs) {
    mockConfig.addAll(configs);
  }

  Future<void> initShare(List<DataModelChangeListener> models) async {
   await Share.instance.init(models);
  }
}
