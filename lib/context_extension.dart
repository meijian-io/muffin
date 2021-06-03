import 'package:flutter/material.dart';
import 'package:muffin/navigator/muffin_navigator.dart';
import 'package:muffin/navigator/navigator_stack_manager.dart';

extension ContextExtensions on BuildContext {
  NavigatorStackManager get muffin => MuffinNavigator.of(this);
}
