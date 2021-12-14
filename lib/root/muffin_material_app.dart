import 'package:flutter/material.dart';
import 'package:muffin/muffin.dart';
import 'package:muffin/navigator/page_route.dart';

class MuffinMaterialApp extends StatelessWidget {
  final RouterDelegate<Object>? routerDelegate;
  final RouteInformationParser<Object>? routeInformationParser;
  final BackButtonDispatcher? backButtonDispatcher;
  final RouteInformationProvider? routeInformationProvider;
  final MuffinPage? notFoundRoute;
  final List<MuffinPage>? muffinPages;

  MuffinMaterialApp(
      {Key? key,
      RouterDelegate<Object>? routerDelegate,
      RouteInformationParser<Object>? routeInformationParser,
      this.backButtonDispatcher,
      this.routeInformationProvider,
      required this.muffinPages,
      this.notFoundRoute})
      : routerDelegate = routerDelegate ??=
            Muffin.createDelegate(notFoundRoute: notFoundRoute),
        routeInformationParser =
            routeInformationParser ??= Muffin.createInformationParser(),
        super(key: key) {
    Muffin.routerDelegate = routerDelegate;
    Muffin.routeInformationParser = routeInformationParser;
    Muffin.addPages(muffinPages!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: routerDelegate!,
      routeInformationParser: routeInformationParser!,
      backButtonDispatcher: backButtonDispatcher,
      routeInformationProvider: routeInformationProvider,
    );
  }
}
