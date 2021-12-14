import 'package:muffin/navigator/page_route.dart';
import 'package:muffin/navigator/router_delegate.dart';

///[MuffinRouterDelegate].toNamed(String page) 方法，解析 page，获取匹配到的[MuffinPage]
///解析方法为[ParseRouteTree] matchRoute 方法，并携带page参数的解析，以及[arguments]
class RouteDecoder {
  final List<MuffinPage> treeBranch;
  final Map<String, String> parameters;
  final Object? arguments;

  MuffinPage? get currentRoute => treeBranch.isEmpty ? null : treeBranch.last;

  RouteDecoder(
    this.treeBranch,
    this.parameters,
    this.arguments,
  );

  void replaceArguments(Object? arguments) {
    final _route = currentRoute;
    if (_route != null) {
      final index = treeBranch.indexOf(_route);
      treeBranch[index] = _route.copy(arguments: arguments);
    }
  }

  void replaceParameters(Map<String, String> params) {
    final _route = currentRoute;
    if (_route != null) {
      final index = treeBranch.indexOf(_route);
      treeBranch[index] = _route.copy(parameters: params);
    }
  }

  @override
  String toString() {
    return 'RouteDecoder(route: ${currentRoute?.toString()})';
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

    // /home/profile/123 => home,profile,123 => /,/home,/home/profile,/home/profile/123
    final split = uri.path.split('/').where((element) => element.isNotEmpty);
    var curPath = '/';
    final cumulativePaths = <String>[
      '/',
    ];
    for (var item in split) {
      if (curPath.endsWith('/')) {
        curPath += '$item';
      } else {
        curPath += '/$item';
      }
      cumulativePaths.add(curPath);
    }

    print('split path end: $cumulativePaths');

    final treeBranch = cumulativePaths
        .map((e) => MapEntry(e, _findRoute(e)))
        .where((element) => element.value != null)
        .map((e) => MapEntry(e.key, e.value!))
        .toList();

    final params = Map<String, String>.from(uri.queryParameters);
    print('parse params: $params');

    if (treeBranch.isNotEmpty) {
      //route is found, do further parsing to get nested query params
      final lastRoute = treeBranch.last;
      final parsedParams = _parseParams(name, lastRoute.value.path);
      if (parsedParams.isNotEmpty) {
        params.addAll(parsedParams);
      }
      //copy parameters to all pages.
      final mappedTreeBranch = treeBranch
          .map(
            (e) => e.value.copy(
              parameters: {
                if (e.value.parameters != null) ...e.value.parameters!,
                ...params,
              },
              name: e.key,
            ),
          )
          .toList();
      print('matched route in flutter : $mappedTreeBranch');
      return RouteDecoder(
        mappedTreeBranch,
        params,
        arguments,
      );
    }

    print('route not found in flutter');
    //route not found
    return RouteDecoder(
      treeBranch.map((e) => e.value).toList(),
      params,
      arguments,
    );
  }

  MuffinPage? _findRoute(String name) {
    return routes.firstWhereOrNull(
      (route) => route.path.regex.hasMatch(name),
    );
  }

  Map<String, String> _parseParams(String path, PathDecoded routePath) {
    final params = <String, String>{};
    var idx = path.indexOf('?');
    if (idx > -1) {
      path = path.substring(0, idx);
      final uri = Uri.tryParse(path);
      if (uri != null) {
        params.addAll(uri.queryParameters);
      }
    }
    var paramsMatch = routePath.regex.firstMatch(path);

    for (var i = 0; i < routePath.keys.length; i++) {
      var param = Uri.decodeQueryComponent(paramsMatch![i + 1]!);
      params[routePath.keys[i]!] = param;
    }
    return params;
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
