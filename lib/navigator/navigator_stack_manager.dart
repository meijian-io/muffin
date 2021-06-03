import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muffin/navigator/muffin_navigator.dart';

///管理所有的路由和页面信息
class NavigatorStackManager extends ChangeNotifier {
  ///所有路由
  final Map<Pattern, MuffinPageBuilder> routes;

  final _pages = <Page>[];
  final _uris = <Uri>[];

  List<Page> get pages => UnmodifiableListView(_pages);

  NavigatorStackManager({required this.routes});

  Future<void> push(Uri uri, {dynamic arguments}) {
    bool _findRoute = false;
    for (int i = 0; i < routes.keys.length; i++) {
      final key = routes.keys.elementAt(i);
      if (key.matchAsPrefix(uri.path)?.group(0) == uri.path) {
        ///第一个页面若已经push 就不再push了
        if (_uris.contains(uri) && key == routes.keys.first) {
          _findRoute = true;
          break;
        }

        ///添加
        _pages.add(routes[key]!(uri, arguments));
        _uris.add(uri);

        _findRoute = true;
        break;
      }
    }

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
      _uris.add(uri);
    }

    notifyListeners();

    //TODO response call back
    return SynchronousFuture(null);
  }

  void pop() {
    if (_pages.length > 1) {
      removeLastUri();
    } else {
      print('can not pop');
    }
  }

  void removeLastUri() {
    _pages.removeLast();
    _uris.removeLast();
    notifyListeners();
  }
}
