import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muffin/channel/navigator_channel.dart';
import 'package:muffin/navigator/muffin_navigator.dart';

///管理所有的路由和页面信息
class NavigatorStackManager extends ChangeNotifier {
  /// if multiple is true, will not call channel method
  final bool multiple;

  ///所有路由
  final Map<Pattern, MuffinPageBuilder> routes;

  final _pages = <Page>[];
  final _uris = <Uri>[];

  ///callbacks, use for push async and pop with result
  Map<Uri, Completer<dynamic>>? callbacks = {};

  List<Page> get pages => UnmodifiableListView(_pages);

  NavigatorStackManager({required this.routes, required this.multiple});

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
    if (multiple) {
      ///async native NavigatorStack
      await NavigatorChannel.push(uri.path);
    }
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
  /// same as [popUntil(uris.last)]
  void pop<T extends Object>([T? result]) async {
    if (multiple) {
      String target = await NavigatorChannel.findPopTarget();
      popUntil(Uri.parse(target), result);
    } else {
      if (_uris.length <= 1) {
        return;
      }
      popUntil(_uris[_uris.length - 2], result);
    }
  }

  /// pop until a page, find the first match [target], if not find in this navigator,
  /// find in native, this way will remove all un match VC and route
  ///
  /// eg: N1(/main) F1(/home) F1(/first) [popUntil(/main)] will remove /home /first and VC(F1)
  void popUntil<T extends Object>(Uri target, [T? result]) {
    ///find in current routes, remove top
    if (found(target)) {
      bool findTarget = false;
      while (!findTarget) {
        if (_uris.isNotEmpty) {
          Uri temp = _uris.last;
          if (temp.path == target.path) {
            findTarget = true;
            callbacks![temp]!.complete(result);
          } else {
            _uris.removeLast();
            _pages.removeLast();
          }
        } else {
          findTarget = true;
        }
      }
      notifyListeners();
    } else {
      print('not find ${target.path} in Uris');
    }
    if (multiple) {
      /// multiply flutters should chat with native
      NavigatorChannel.popUntil(target.path, result);
    }
  }

  void removeLastUri() {
    _pages.removeLast();
    _uris.removeLast();
    notifyListeners();
  }

  bool found(Uri uri) {
    bool foundMatching = false;
    for (Uri element in _uris) {
      if (element.path == uri.path) {
        foundMatching = true;
      }
    }
    return foundMatching;
  }
}
