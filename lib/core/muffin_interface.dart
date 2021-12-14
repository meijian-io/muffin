import 'package:flutter/material.dart';
import 'mock.dart';

abstract class MuffinInterface {
  var _key = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get key => _key;

  RouterDelegate? routerDelegate;
  RouteInformationParser? routeInformationParser;
  List<MockConfig> mockConfig = [];
}
