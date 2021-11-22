import 'dart:async';

import 'package:flutter/material.dart';
import 'package:muffin/muffin.dart';
import 'package:muffin/navigator/page_route.dart';

enum PopMode {
  History,
  Page,
}

class MuffinRouterDelegate extends RouterDelegate<RouteConfig>
    with ChangeNotifier {
  GlobalKey<NavigatorState> get navigatorKey => Muffin.key;

  ///历史页面Route
  final List<RouteConfig> history = <RouteConfig>[];

  final MuffinPage notFoundRoute;

  MuffinRouterDelegate({MuffinPage? notFoundRoute})
      : notFoundRoute = notFoundRoute ??
            MuffinPage(
                name: '/404',
                page: () => Scaffold(
                      body: Text('Route page not found'),
                    )) {
    print('MuffinRouterDelegate has created!!!');
  }

  @override
  RouteConfig? get currentConfiguration {
    if (history.isEmpty) return null;
    final route = history.last;
    return route;
  }

  @override
  Widget build(BuildContext context) {
    final pages = getHistoryPages();
    if (pages.length == 0) return SizedBox.shrink();
    return Navigator(
      key: navigatorKey,
      pages: pages,
    );
  }

  /// gets the [MuffinPage]s from the current history entry
  List<MuffinPage> getHistoryPages() {
    final currentHistory = currentConfiguration;
    if (currentHistory == null) return <MuffinPage>[];
    return history.map((e) => e.page).toList();
  }

  ///[Router.backButtonDispatcher]，系统返回按钮回调
  ///返回 true 表示自己拦截，返回 false 则跟随系统导航返回
  @override
  Future<bool> popRoute({
    Object? result,
    PopMode popMode = PopMode.History,
  }) async {
    //Returning false will cause the entire app to be popped.
    print('handle system pop!!!');
    final wasPopup = await handlePopupRoutes(result: result);
    if (wasPopup) {
      print(
          'pop route, use Navigator.push(ModalRoute route), will user Navigator.pop()');
      return true;
    }
    print('pop route, remove top route and notifyListeners');
    final _popped = await _pop(popMode);
    notifyListeners();
    if (_popped != null) {
      //emulate the old pop with result
      return true;
    }
    return false;
  }

  Future<RouteConfig?> _pop(PopMode mode) async {
    switch (mode) {
      case PopMode.History:
        return await _popHistory();
      case PopMode.Page:
        return null;
      default:
        return null;
    }
  }

  Future<RouteConfig?> _popHistory() async {
    if (!_canPopHistory()) return null;
    return await _doPopHistory();
  }

  Future<RouteConfig?> _doPopHistory() async {
    return await _unsafeHistoryRemoveAt(history.length - 1);
  }

  bool _canPopHistory() {
    return history.length > 1;
  }

  Future<RouteConfig?> _unsafeHistoryRemoveAt(int index) async {
    if (index == history.length - 1 && history.length > 1) {
      //removing WILL update the current route
      final toCheck = history[history.length - 2];
      final resMiddleware = await runMiddleware(toCheck);
      if (resMiddleware == null) return null;
      history[history.length - 2] = resMiddleware;
    }
    return history.removeAt(index);
  }

  Future<RouteConfig?> runMiddleware(RouteConfig config) async {
    final middlewares = null;
    if (middlewares == null) {
      return config;
    }
    var iterator = config;
    for (var item in middlewares) {
      var redirectRes = await item.redirectDelegate(iterator);
      if (redirectRes == null) return null;
      iterator = redirectRes;
    }
    return iterator;
  }

  Future<bool> handlePopupRoutes({
    Object? result,
  }) async {
    Route? currentRoute;
    navigatorKey.currentState!.popUntil((route) {
      currentRoute = route;
      return true;
    });
    if (currentRoute is PopupRoute) {
      return await navigatorKey.currentState!.maybePop(result);
    }
    return false;
  }

  @override
  Future<void> setNewRoutePath(RouteConfig configuration) async {
    await pushHistory(configuration);
  }

  /// Adds a new history entry and waits for the result
  Future<void> pushHistory(
    RouteConfig config, {
    bool rebuildStack = true,
  }) async {
    //this changes the currentConfiguration
    await _pushHistory(config);
    if (rebuildStack) {
      notifyListeners();
    }
  }

  Future<void> _pushHistory(RouteConfig config) async {
    await _unsafeHistoryAdd(config);
  }

  Future<void> _unsafeHistoryAdd(RouteConfig config) async {
    final res = await runMiddleware(config);
    if (res == null) return;
    history.add(res);
  }

  final _allCompleters = <MuffinPage, Completer>{};

  Future<T> toNamed<T>(
    String page, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
      print('toNamed with parameters, full page path is $page');
    }
    print('toNamed with page: $page');
    final decoder = Muffin.routeTree.matchRoute(page, arguments: arguments);
    decoder.replaceArguments(arguments);

    print('page path match route, get decoder: $decoder');
    final completer = Completer<T>();

    if (decoder.currentRoute != null) {
      _allCompleters[decoder.currentRoute!] = completer;
      await pushHistory(
        RouteConfig(
          page: decoder.currentRoute!,
          location: page,
          state: null,
        ),
      );

      return completer.future;
    } else {
      ///TODO: IMPLEMENT ROUTE NOT FOUND
      return Future.value();
    }
  }
}
