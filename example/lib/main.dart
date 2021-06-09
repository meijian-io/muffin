import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muffin/navigator/muffin_navigator.dart';
import 'package:muffin/navigator/muffin_page.dart';

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
  final navigator = MuffinNavigator(
      initRoute: '/home',
      routes: {
        '/home': (uri, arguments) => MuffinRoutePage(child: HomeScreen()),
        '/first': (uri, arguments) => MuffinRoutePage(
                child: FirstScreen(
              arguments: arguments,
            ))
      },
      multiple: true);

  return MaterialApp.router(
    routeInformationParser: MuffinInformationParser(),
    routerDelegate: navigator,
    backButtonDispatcher: MuffinBackButtonDispatcher(navigator: navigator),
  );
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
