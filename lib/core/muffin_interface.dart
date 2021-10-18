import 'package:flutter/material.dart';
import 'mock.dart';

abstract class MuffinInterface {
  RouterDelegate? routerDelegate;
  RouteInformationParser? routeInformationParser;
  List<MockConfig> mockConfig = [];
}
