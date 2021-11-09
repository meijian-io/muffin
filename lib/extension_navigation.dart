import 'package:muffin/core/muffin_interface.dart';
import 'package:muffin/navigator/page_route.dart';
import 'package:muffin/navigator/router_delegate.dart';
import 'package:muffin/sharing/data_model_change_listener.dart';
import 'package:muffin/sharing/share.dart';

import 'core/mock.dart';
import 'core/parse_route.dart';
import 'navigator/information_parser.dart';

extension MuffinNavigation on MuffinInterface {
  MuffinRouterDelegate createDelegate({MuffinPage<dynamic>? notFoundRoute}) {
    if (routerDelegate == null) {
      return routerDelegate =
          MuffinRouterDelegate(notFoundRoute: notFoundRoute);
    } else {
      return routerDelegate as MuffinRouterDelegate;
    }
  }

  MuffinInformationParser createInformationParser({String initialRoute = '/'}) {
    if (routeInformationParser == null) {
      return routeInformationParser = MuffinInformationParser(
        initialRoute: initialRoute,
      );
    } else {
      return routeInformationParser as MuffinInformationParser;
    }
  }

  static late final _routeTree = ParseRouteTree(routes: []);

  ParseRouteTree get routeTree => _routeTree;

  MuffinRouterDelegate get muffinRouterDelegate =>
      routerDelegate as MuffinRouterDelegate;

  void addPages(List<MuffinPage> muffinPages) {
    routeTree.addRoutes(muffinPages);
  }

  Future<T> toNamed<T>(
    String page, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    return muffinRouterDelegate.toNamed(page,
        arguments: arguments, parameters: parameters);
  }
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
