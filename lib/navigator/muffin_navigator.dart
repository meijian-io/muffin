/**
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muffin/channel/navigator_channel.dart';
import 'package:muffin/navigator/muffin_page.dart';
import 'package:muffin/navigator/route_config.dart';

import 'navigator_stack_manager.dart';

typedef MuffinPageBuilder = Page Function(dynamic params);

class MuffinNavigator extends RouterDelegate<RouteConfig>
    with PopNavigatorRouterDelegateMixin<RouteConfig>, ChangeNotifier {
  ///get manager instance
  static NavigatorStackManager of(BuildContext context) {
    return (Router.of(context).routerDelegate as MuffinNavigator)
        .navigatorStackManager;
  }

  late NavigatorStackManager navigatorStackManager;

  late String initRoute = '/';

  late dynamic initArguments = {};

  MuffinNavigator(
      {required Map<String, MuffinPageBuilder> routes,
      String initRoute = '/',
      dynamic initArguments,
      Widget? emptyWidget}) {
    this.initRoute = initRoute;
    this.initArguments = initArguments;
    navigatorStackManager = NavigatorStackManager(
        routes: routes,
        emptyPage: MaterialPage(child: emptyWidget ?? createEmptyWidget()));
    navigatorStackManager.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: navigatorStackManager.pages.isEmpty
          ? [MuffinRoutePage(child: Container())]
          : [for (final page in navigatorStackManager.pages) page],
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
  Future<void> setNewRoutePath(RouteConfig configuration) async {
    ///2. setNewRoutePath
    print('setNewRoutePath ${configuration.toString()}');
    return navigatorStackManager.push(configuration.path!,
        arguments: configuration.arguments);
  }

  Widget createEmptyWidget() {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: const Center(
          child: Text('Page not found'),
        ),
      ),
    );
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
*/
