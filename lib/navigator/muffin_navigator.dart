import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'navigator_stack_manager.dart';

typedef MuffinPageBuilder = Page Function(Uri uri, dynamic params);

class MuffinNavigator extends RouterDelegate<Uri>
    with PopNavigatorRouterDelegateMixin<Uri>, ChangeNotifier {
  ///get manager instance
  static NavigatorStackManager of(BuildContext context) {
    return (Router.of(context).routerDelegate as MuffinNavigator)
        .navigatorStackManager;
  }

  late NavigatorStackManager navigatorStackManager;

  final String initRoute;

  MuffinNavigator({
    required this.initRoute,
    required Map<Pattern, MuffinPageBuilder> routes,
    bool multiple = false,
  }) {
    navigatorStackManager =
        NavigatorStackManager(routes: routes, multiple: multiple);
    navigatorStackManager.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [for (final page in navigatorStackManager.pages) page],
      onPopPage: (route, result) {
        ///监听Navigator pop 只有触发 [Navigator.pop]时才会回调，一般为material下的默认导航返回
        if (!route.didPop(result)) {
          return false;
        }
        if (navigatorStackManager.pages.length > 1) {
          navigatorStackManager.pop();
          return true;
        }
        return false;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  ///Navigator初始化时默认为 '/'，标记已经是当前home
  @override
  Future<void> setNewRoutePath(Uri configuration) {
    ///2. setNewRoutePath
    print('setNewRoutePath ${configuration.toString()}');
    if (configuration.toString() == '/') {
      return navigatorStackManager.push(Uri.parse(initRoute));
    }
    return navigatorStackManager.push(configuration);
  }
}

class MuffinInformationParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async {
    ///1. parseRouteInformation
    print('parseRouteInformation ${routeInformation.location}');
    return Uri.parse(routeInformation.location!);
  }

  @override
  RouteInformation? restoreRouteInformation(Uri configuration) {
    RouteInformation(location: Uri.decodeComponent(configuration.toString()));
  }
}

///监听系统返回事件
class MuffinBackButtonDispatcher extends RootBackButtonDispatcher {
  final MuffinNavigator navigator;

  MuffinBackButtonDispatcher({required this.navigator});

  @override
  Future<bool> didPopRoute() {
    if (navigator.navigatorStackManager.pages.length > 1) {
      navigator.navigatorStackManager.pop();

      /// handle by us
      return Future.value(true);
    }
    navigator.navigatorStackManager.pop();

    /// handle by system , will finish the MuffinFlutterActivity
    return super.didPopRoute();
  }
}
