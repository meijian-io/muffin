import 'package:flutter/material.dart';

class MuffinRoutePage extends Page {
  final String? pageName;
  final Widget? child;
  final bool maintainState;
  final bool fullscreenDialog;
  final Widget Function(Animation<double> animation, Widget child)? transition;

  MuffinRoutePage(
      {this.pageName,
      this.child,
      this.maintainState = true,
      this.fullscreenDialog = false,
      this.transition})
      : super();

  @override
  Route createRoute(BuildContext context) {
    if (transition != null) {
      return PageRouteBuilder(
        settings: this,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        pageBuilder: (context, animation, secondaryAnimation) => child!,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return transition!(animation, child);
        },
      );
    } else {
      return MaterialPageRoute(
        settings: this,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        builder: (context) {
          return child!;
        },
      );
    }
  }
}
