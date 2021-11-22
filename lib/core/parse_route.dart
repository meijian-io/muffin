import 'package:muffin/navigator/page_route.dart';
import 'package:muffin/navigator/router_delegate.dart';

///[MuffinRouterDelegate].toNamed(String page) 方法，解析 page，获取匹配到的[MuffinPage]
///解析方法为[ParseRouteTree] matchRoute 方法，并携带page参数的解析，以及[arguments]
class RouteDecoder {
  final List<MuffinPage> routes;
  final Map<String, String> parameters;
  final Object? arguments;

  MuffinPage? get currentRoute => routes.isEmpty ? null : routes.first;

  RouteDecoder({
    MuffinPage? route,
    required this.parameters,
    required this.arguments,
  }) : routes = [route!];

  void replaceArguments(Object? arguments) {
    final _route = currentRoute;
    if (_route != null) {
      final index = routes.indexOf(_route);
      routes[index] = _route.copy(arguments: arguments);
    }
  }

  void replaceParameters(Map<String, String> params) {
    final _route = currentRoute;
    if (_route != null) {
      final index = routes.indexOf(_route);
      routes[index] = _route.copy(parameters: params);
    }
  }

  @override
  String toString() {
    return 'RouteDecoder(route: ${currentRoute!.toString()})';
  }
}

///[addRoutes]方法将会在初始化时调用，将树形结构的路由表转化为[routes]，以供之后 push 时
///通过 [matchRoute] 匹配 [MuffinPage], 参数复制等， 封装成[RouteDecoder]返回
///
class ParseRouteTree {
  final List<MuffinPage> routes;

  ParseRouteTree({required this.routes});

  RouteDecoder matchRoute(String name, {Object? arguments}) {
    final uri = Uri.parse(name);
    String path = uri.path;
    print('match path start: $path');
    var matched = _findRoute(path);
    if (matched != null) {
      print('matched route in flutter : $matched');
      final params = Map<String, String>.from(uri.queryParameters);
      return RouteDecoder(
          route: matched, parameters: params, arguments: arguments)
        ..replaceParameters(params);
    } else {
      //find in native
    }

    //route not found
    return RouteDecoder(
      route: null,
      parameters: {},
      arguments: arguments,
    );
  }

  MuffinPage? _findRoute(String name) {
    return routes.firstWhereOrNull(
      (route) => route.name.contains(name),
    );
  }

  ///将树形结构，子route拼接父route的path，保存到[routes]
  void addRoutes(List<MuffinPage<dynamic>> muffinPages) {
    for (final route in muffinPages) {
      addRoute(route);
    }
    print('<---- MuffinPages has saved ---->');
    for (var value in routes) {
      print(value.toString());
    }
    print('<---- MuffinPages log finish ---->');
  }

  void addRoute(MuffinPage route) {
    routes.add(route);
    // Add Page children.
    for (var page in _flattenPage(route)) {
      addRoute(page);
    }
  }

  List<MuffinPage> _flattenPage(MuffinPage route) {
    final result = <MuffinPage>[];
    if (route.children.isEmpty) {
      return result;
    }

    final parentPath = route.name;
    for (var page in route.children) {
      result.add(
        _addChild(
          page,
          parentPath,
        ),
      );
    }
    return result;
  }

  /// Change the Path for a [MuffinPage
  MuffinPage _addChild(MuffinPage origin, String parentPath) => origin.copy(
        name: (parentPath + origin.name).replaceAll(r'//', '/'),
      );
}

extension FirstWhereExt<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
