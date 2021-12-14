import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:muffin/muffin.dart';
import 'package:muffin/navigator/page_route.dart';

class MuffinInformationParser extends RouteInformationParser<RouteConfig> {
  /// 可以通过[Uri]解析的 route
  final String initialRoute;

  ///也可以添加一些在[initialRoute]中无法得到的参数
  final Map<String, Object> arguments;

  final UrlParser urlParser;

  MuffinInformationParser(this.urlParser,
      {this.initialRoute = '/', this.arguments = const {}})
      : assert(arguments is Map, 'arguments should be Map') {
    print('MuffinInformationParser is created !');
  }

  @override
  SynchronousFuture<RouteConfig> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    print(
        'MuffinInformationParser: route location: ${routeInformation.location}, initRoute: $initialRoute');

    Uri uri = Uri.parse(initialRoute);
    final matchResult = Muffin.routeTree
        .matchRoute(urlParser.getPath(uri), arguments: arguments);
    arguments.addAll(urlParser.getParams(uri));
    matchResult.replaceArguments(arguments);
    return SynchronousFuture(
      RouteConfig(
        currentTreeBranch: matchResult.treeBranch,
        location: urlParser.getPath(uri),
        state: routeInformation.state,
      ),
    );
  }

  @override
  RouteInformation restoreRouteInformation(RouteConfig config) {
    return RouteInformation(location: config.location, state: config.state);
  }
}

///因为从Native根据一个url路径打开一个Flutter页面，不同的项目设计可能不同
///比如美间 schema定义为
///meijianclient://meijian.io?url=home/first&name=uri_test
///meijianclient://meijian.io?url=home&name=uri_test
///其中path 参数需要通过 query 拿到，其他的参数也需要特定解析
///继承这个类可以实现自己的解析，并提供通用的解析方式，默认为通用的[DefaultUrlParser]
abstract class UrlParser {
  ///解析 path，将会通过path匹配[MuffinPage]
  String getPath(Uri uri);

  ///解析参数，将会复制到[MuffinPage] 的 arguments中，可通过[Muffin.arguments]获取
  Map<String, String> getParams(Uri uri);
}

class DefaultUrlParser extends UrlParser {
  @override
  Map<String, String> getParams(Uri uri) {
    Map<String, String> params = uri.queryParameters;
    return params;
  }

  @override
  String getPath(Uri uri) {
    String path = uri.path;
    if (!path.startsWith('/')) {
      path = '/' + path;
    }
    return path;
  }
}
