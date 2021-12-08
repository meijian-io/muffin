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
  final List<RouteConfig> _history = <RouteConfig>[];

  final MuffinPage notFoundRoute;

  ///callbacks, use for push async and pop with result
  final Map<RouteConfig, Completer<dynamic>> _callbacks = {};

  MuffinRouterDelegate({MuffinPage? notFoundRoute})
      : notFoundRoute = notFoundRoute ??
            MuffinPage(
                name: '/404',
                page: () => Scaffold(
                      body: Text('Route page not found'),
                    )) {
    print('MuffinRouterDelegate has created!!!');
    NavigatorChannel.channel.setMethodCallHandler((call) {
      switch (call.method) {
        case 'popUntil':
          popUntil(call.arguments['pageName'], call.arguments['result']);
          break;
        case "pop":
          pop();
          break;
        case 'syncDataModel':
          print('native syncDataModel , flutter received : ${call.arguments}');
          Muffin.syncDataModel(Map<String, dynamic>.from(call.arguments));
          break;
      }
      return Future.value({});
    });
  }

  @override
  RouteConfig? get currentConfiguration {
    if (_history.isEmpty) return null;
    final route = _history.last;
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
    return _history.map((e) => e.page).toList();
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
    await pop(result);
    return true;
  }

  /// pop with arguments
  /// similar to [Navigator.of(context).pop]
  /// same as [popUntil(uris.last)]
  Future<void> pop<T extends Object>([T? result]) async {
    String target = await NavigatorChannel.findPopTarget();
    print('find pop target in native $target');
    if (target == '') {
      /// not find target in native,it's not 'multiple' mode, find in Flutter
      if (_history.length <= 1) {
        return;
      }
      popUntil(_history[_history.length - 2].page.name, result);
    } else {
      ///find int native, it's 'multiple' mode
      popUntil(target, result);
    }
  }

  /// pop until a page, find the first match [target], if not find in this navigator,
  /// find in native, this way will remove all un match VC and route
  ///
  /// eg: N1(/main) F1(/home) F1(/first) [popUntil(/main)] will remove /home /first and VC(F1)
  void popUntil<T extends Object>(String target, [T? result]) async {
    ///find in current routes, remove top
    if (foundInCurrentRoutes(target)) {
      bool findTarget = false;
      while (!findTarget) {
        if (_history.isNotEmpty) {
          RouteConfig temp = _history.last;
          if (temp.page.name == target) {
            findTarget = true;
            _callbacks[temp]?.complete(result);
          } else {
            _history.removeLast();
          }
        } else {
          findTarget = true;
        }
      }
      notifyListeners();
    } else {
      print('not find ${target} in Uris');
    }

    /// multiply flutters should chat with native
    await NavigatorChannel.popUntil(target, result);
  }

  bool foundInCurrentRoutes(String path) {
    bool foundMatching = false;
    for (RouteConfig element in _history) {
      if (element.page.name == path) {
        foundMatching = true;
      }
    }
    return foundMatching;
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
    await _pushHistory(configuration);
  }

  /// Adds a new history entry and waits for the result
  Future<void> _pushHistory(RouteConfig config) async {
    await _unsafeHistoryAdd(config);
    notifyListeners();
  }

  Future<void> _unsafeHistoryAdd(RouteConfig config) async {
    _history.add(config);
    await NavigatorChannel.syncFlutterStack(config.page.name);
  }

  Future<T> pushNamed<T>(
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

    ///find page in Flutter
    if (decoder.currentRoute != null) {
      RouteConfig routeConfig = RouteConfig(
        page: decoder.currentRoute!,
        location: page,
        state: null,
      );

      ///set to current route
      _callbacks[_history.last] = completer;
      await _pushHistory(routeConfig);
    } else {
      /// found in native
      bool find = await NavigatorChannel.pushNamed(page, arguments);
      print('not found in Flutter, find int native $find');
      if (!find) {
        ///will show not found
        RouteConfig notFound = RouteConfig(
          page: notFoundRoute,
          location: page,
          state: null,
        );
        _callbacks[_history.last] = completer;
        await _pushHistory(notFound);
      }
    }
    return completer.future;
  }

  T arguments<T>() {
    return currentConfiguration?.page.arguments as T;
  }

  Map<String, String> get parameters {
    return currentConfiguration?.page.parameters ?? {};
  }
}
