import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muffin/channel/navigator_channel.dart';
import 'package:muffin/navigator/muffin_navigator.dart';
import 'package:muffin/navigator/route_config.dart';
import 'package:muffin/sharing/share.dart';

///管理所有的路由和页面信息
class NavigatorStackManager extends ChangeNotifier {
  ///所有路由
  final Map<String, MuffinPageBuilder> routes;

  final Page emptyPage;

  final _pages = <Page>[];
  final _history = <RouteConfig>[];

  ///callbacks, use for push async and pop with result
  Map<RouteConfig, Completer<dynamic>>? callbacks = {};

  List<Page> get pages => UnmodifiableListView(_pages);

  NavigatorStackManager({required this.routes, required this.emptyPage}) {
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
          Share.instance
              .syncDataModel(Map<String, dynamic>.from(call.arguments));
          break;
      }
      return Future.value({});
    });
  }

  /// push a uri, if find the target uri, will add a callback
  /// internal push, find target uri-> push, otherwise push a [No find page]
  Future<void> _push(String path, {dynamic arguments}) async {
    bool _findRoute = false;
    Pattern _findPattern = '/';
    for (int i = 0; i < routes.keys.length; i++) {
      final key = routes.keys.elementAt(i);
      if (key == path) {
        ///第一个页面若已经push 就不再push了
        if (foundInCurrentRoutes(path) && key == routes.keys.first) {
          _findRoute = true;
          break;
        }
        _findPattern = key;
        _findRoute = true;
        break;
      }
    }

    ///create page
    if (!_findRoute) {
      _pages.add(emptyPage);
    } else {
      _pages.add(routes[_findPattern]!(arguments));
    }

    ///add to uris
    _history.add(RouteConfig(path: path, arguments: arguments));

    notifyListeners();

    ///sync native NavigatorStack

    await NavigatorChannel.syncFlutterStack(path);

    return SynchronousFuture(null);
  }

  /// only used in [MuffinNavigator] init [MuffinNavigator.setNewRoutePath]
  Future<void> push(String path, {dynamic arguments}) =>
      _push(path, arguments: arguments);

  /// push a page with [String], similar to [Navigator.of(context).pushNamed]
  /// call eg.. - [MuffinNavigator.of(context).pushNamed]
  Future<T?> pushNamed<T extends Object?>(String named,
      [dynamic arguments]) async {
    final Completer<T?> callback = Completer<T?>();

    ///set to current route
    callbacks![_history.last] = callback;

    /// find route , if exit push, else find in native
    if (foundInTotalRoutes(named)) {
      await _push(named, arguments: arguments);
    } else {
      /// found in native
      bool find = await NavigatorChannel.pushNamed(named, arguments);
      if (!find) {
        ///will show not found
        await _push(named, arguments: arguments);
      }
    }
    return callback.future;
  }

  /// pop with arguments
  /// similar to [Navigator.of(context).pop]
  /// same as [popUntil(uris.last)]
  void pop<T extends Object>([T? result]) async {
    String target = await NavigatorChannel.findPopTarget();
    if (target == '') {
      /// not find target in native,it's not 'multiple' mode, find in Flutter
      if (_history.length <= 1) {
        return;
      }
      popUntil(_history[_history.length - 2].path!, result);
    } else {
      ///find int native, it's 'multiple' mode
      popUntil(target, result);
    }
  }

  /// pop until a page, find the first match [target], if not find in this navigator,
  /// find in native, this way will remove all un match VC and route
  ///
  /// eg: N1(/main) F1(/home) F1(/first) [popUntil(/main)] will remove /home /first and VC(F1)
  void popUntil<T extends Object>(String target, [T? result]) {
    ///find in current routes, remove top
    if (foundInCurrentRoutes(target)) {
      bool findTarget = false;
      while (!findTarget) {
        if (_history.isNotEmpty) {
          RouteConfig temp = _history.last;
          if (temp.path == target) {
            findTarget = true;
            callbacks![temp]!.complete(result);
          } else {
            _history.removeLast();
            _pages.removeLast();
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
    NavigatorChannel.popUntil(target, result);
  }

  void removeLastUri() {
    _pages.removeLast();
    _history.removeLast();
    notifyListeners();
  }

  bool foundInCurrentRoutes(String path) {
    bool foundMatching = false;
    for (RouteConfig element in _history) {
      if (element.path == path) {
        foundMatching = true;
      }
    }
    return foundMatching;
  }

  bool foundInTotalRoutes(String path) {
    bool _findRoute = false;
    for (int i = 0; i < routes.keys.length; i++) {
      final key = routes.keys.elementAt(i);
      if (key == path) {
        if (foundInCurrentRoutes(path) && key == routes.keys.first) {
          _findRoute = true;
          break;
        }
        _findRoute = true;
        break;
      }
    }
    return _findRoute;
  }
}
