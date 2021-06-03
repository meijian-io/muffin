import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'first.dart';
import 'home.dart';

///这些定义只能写在 main.dart 中
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(getApp());
}

@pragma('vm:entry-point')
void first() async {
  ///确保 Flutter 通讯渠道已经实例化
  WidgetsFlutterBinding.ensureInitialized();
  var arguments = {};
  runApp(getApp());
}

@pragma('vm:entry-point')
void second() async {
  WidgetsFlutterBinding.ensureInitialized();
  var arguments = {};
  runApp(getApp());
}

///get a App with dif initialRoute
Widget getApp() {
  return MaterialApp.router(
    backButtonDispatcher: MyBackDispatcher(),
    routeInformationParser: MyRouteParser(),
    routerDelegate: MyRouteDelegate(),
  );
}

class MyBackDispatcher extends RootBackButtonDispatcher {
  @override
  Future<bool> didPopRoute() {
    return invokeCallback(Future.value(false));
  }
}

class MyRouteParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    return SynchronousFuture(routeInformation.location!);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}

class MyRouteDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  static MyRouteDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is MyRouteDelegate, 'Delegate type must match');
    return delegate as MyRouteDelegate;
  }

  Map<String, Page> pages = {
    '/home': MyPage('/home', {}, builder: (context) => HomeScreen()),
    '/first': MyPage('/first', {}, builder: (context) => FirstScreen())
  };
  List<String> stack = ['/home'];

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  void push(String name) {
    stack.add(name);
    notifyListeners();
  }

  void remove(String routeName) {
    stack.remove(routeName);
    notifyListeners();
  }

  void pop(String result) {
    navigatorKey!.currentState!.pop(result);
  }

  @override
  Future<bool> popRoute() {
    if (stack.length > 1) {
      stack.removeLast();
      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: (route, result) {
        print(result);
        if (stack.last == route.settings.name) {
          stack.remove(route.settings.name);
          notifyListeners();
        }
        return route.didPop(result);
      },
      pages: stack.map((e) => pages[e]!).toList(),
      //initialRoute: '/home',
      /*onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
                settings: settings, builder: (context) => HomeScreen());
          case '/first':
            return MaterialPageRoute(
                settings: settings, builder: (context) => FirstScreen());
        }
      }*/
    );
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    return SynchronousFuture<void>(null);
  }
}

class MyPage extends Page {
  final WidgetBuilder builder;
  final String name;
  final Object arguments;

  MyPage(this.name, this.arguments, {required this.builder})
      : super(name: name, arguments: arguments);

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: builder,
    );
  }
}

class SplashLoading extends StatefulWidget {
  const SplashLoading({Key? key}) : super(key: key);

  @override
  _SplashLoadingState createState() => _SplashLoadingState();
}

class _SplashLoadingState extends State<SplashLoading> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
