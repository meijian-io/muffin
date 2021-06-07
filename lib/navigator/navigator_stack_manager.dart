import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muffin/channel/navigator_channel.dart';
import 'package:muffin/navigator/muffin_navigator.dart';

///管理所有的路由和页面信息
class NavigatorStackManager extends ChangeNotifier {
  ///所有路由
  final Map<Pattern, MuffinPageBuilder> routes;

  final _pages = <Page>[];
  final _uris = <Uri>[];

  ///callbacks, use for push async and pop with result
  Map<Uri, Completer<dynamic>>? callbacks = {};

  List<Page> get pages => UnmodifiableListView(_pages);

  NavigatorStackManager({required this.routes});

  /// push a uri, if find the target uri, will add a callback
  /// internal push, find target uri-> push, otherwise push a [No find page]
  Future<void> _push(Uri uri, {dynamic arguments}) async {
    bool _findRoute = false;
    Pattern _findPattern = '/';
    for (int i = 0; i < routes.keys.length; i++) {
      final key = routes.keys.elementAt(i);
      if (key.matchAsPrefix(uri.path)?.group(0) == uri.path) {
        ///第一个页面若已经push 就不再push了
        if (_uris.contains(uri) && key == routes.keys.first) {
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
      var page = MaterialPage(
        child: Scaffold(
          body: Container(
            child: const Center(
              child: Text('Page not found'),
            ),
          ),
        ),
      );
      _pages.add(page);
    } else {
      _pages.add(routes[_findPattern]!(uri, arguments));
    }

    ///add to uris
    _uris.add(uri);

    notifyListeners();

    ///async native NavigatorStack
    await NavigatorChannel.push(uri.path);
    return SynchronousFuture(null);
  }

  /// only used in [MuffinNavigator] init [MuffinNavigator.setNewRoutePath]
  Future<void> push(Uri uri, {dynamic arguments}) =>
      _push(uri, arguments: arguments);

  /// push a page with [Uri], similar to [Navigator.of(context).pushNamed]
  /// call eg.. - [MuffinNavigator.of(context).pushNamed]
  Future<T?> pushNamed<T extends Object?>(Uri uri, {dynamic arguments}) async {
    final Completer<T?> callback = Completer<T?>();

    ///set to current route
    callbacks![_uris.last] = callback;
    await _push(uri, arguments: arguments);
    return callback.future;
  }

  /// pop with arguments
  /// similar to [Navigator.of(context).pop]
  void pop<T extends Object>([T? result]) {
    if (_pages.length > 1) {
      removeLastUri();

      ///find call back
      callbacks![_uris.last]!.complete(result);
    }

    ///async native NavigatorStack
    NavigatorChannel.pop(_uris.last.path);
  }

  void removeLastUri() {
    _pages.removeLast();
    _uris.removeLast();
    notifyListeners();
  }
}
