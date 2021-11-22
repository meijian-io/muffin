import 'package:flutter/material.dart';

@immutable
class PathDecoded {
  const PathDecoded(this.regex, this.keys);

  final RegExp regex;
  final List<String?> keys;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PathDecoded &&
        other.regex == regex; // && listEquals(other.keys, keys);
  }

  @override
  int get hashCode => regex.hashCode;
}

typedef MuffinPageBuilder = Widget Function();

///page 支持多级
/// home[discover,mine[settings]]
class MuffinPage<T> extends Page<T> {
  final MuffinPageBuilder page;
  final Map<String, String>? parameters;
  final bool preventDuplicates;

  ///参与根导航
  final bool? participatesInRootNavigator;

  @override
  final Object? arguments;

  @override
  final String name;

  final List<MuffinPage> children;
  final MuffinPage? unknownRoute;

  MuffinPage(
      {required this.name,
      required this.page,
      this.parameters,
      this.arguments,
      this.participatesInRootNavigator,
      this.children = const <MuffinPage>[],
      this.preventDuplicates = true,
      this.unknownRoute})
      : super(arguments: arguments, name: name);

  @override
  Route<T> createRoute(BuildContext context) {
    return MuffinPageRoute(
      page: page,
      parameter: parameters,
      settings: this,
      routeName: name,
    );
  }

  MuffinPage<T> copy(
      {MuffinPageBuilder? page,
      Map<String, String>? parameters,
      Object? arguments,
      String? name,
      List<MuffinPage>? children,
      MuffinPage? unknownRoute,
      bool? participatesInRootNavigator}) {
    return MuffinPage(
        name: name ?? this.name,
        page: page ?? this.page,
        parameters: parameters ?? this.parameters,
        arguments: arguments ?? this.arguments,
        children: children ?? this.children,
        unknownRoute: unknownRoute ?? this.unknownRoute,
        participatesInRootNavigator:
            participatesInRootNavigator ?? this.participatesInRootNavigator);
  }

  @override
  String toString() {
    return 'Page($name)';
  }
}

class MuffinPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin {
  final MuffinPageBuilder? page;
  final Map<String, String>? parameter;
  final String? routeName;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  MuffinPageRoute({
    RouteSettings? settings,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    this.page,
    this.parameter,
    this.routeName,
    this.transitionDuration = const Duration(milliseconds: 400),
    bool fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  final bool maintainState;

  @override
  final Duration transitionDuration;

  @override
  Widget buildContent(BuildContext context) {
    //TODO middle ware
    return page!();
  }
}
