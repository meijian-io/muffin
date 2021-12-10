import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:muffin/muffin.dart';

class MuffinInformationParser extends RouteInformationParser<RouteConfig> {
  final String initialRoute;
  final Object arguments;

  MuffinInformationParser({
    this.initialRoute = '/',
    this.arguments = const {},
  }) {
    print('MuffinInformationParser is created !');
  }

  @override
  SynchronousFuture<RouteConfig> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    print(
        'MuffinInformationParser: route location: ${routeInformation.location}');

    final matchResult =
        Muffin.routeTree.matchRoute(initialRoute, arguments: arguments);
    matchResult.replaceArguments(arguments);

    return SynchronousFuture(
      RouteConfig(
        currentTreeBranch: matchResult.treeBranch,
        location: initialRoute,
        state: routeInformation.state,
      ),
    );
  }

  @override
  RouteInformation restoreRouteInformation(RouteConfig config) {
    return RouteInformation(location: config.location, state: config.state);
  }
}
