import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:muffin/muffin.dart';

class MuffinInformationParser extends RouteInformationParser<RouteConfig> {
  final String initialRoute;

  MuffinInformationParser({
    this.initialRoute = '/',
  }) {
    print('MuffinInformationParser is created !');
  }

  @override
  SynchronousFuture<RouteConfig> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    print(
        'MuffinInformationParser: route location: ${routeInformation.location}');
    var location = routeInformation.location;
    if (location == '/') {
      //check if there is a corresponding page
      //if not, relocate to initialRoute
      if (!Muffin.routeTree.routes.any((element) => element.name == '/')) {
        location = initialRoute;
      }
    }

    final matchResult = Muffin.routeTree.matchRoute(location ?? initialRoute);

    return SynchronousFuture(
      RouteConfig(
        page: matchResult.currentRoute!,
        location: location,
        state: routeInformation.state,
      ),
    );
  }

  @override
  RouteInformation restoreRouteInformation(RouteConfig config) {
    return RouteInformation(location: config.location, state: config.state);
  }
}
