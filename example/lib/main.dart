import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:muffin/muffin.dart';
import 'package:muffin/navigator/muffin_navigator.dart';
import 'package:muffin/navigator/muffin_page.dart';
import 'package:muffin_example/basic_info.dart';

import 'first.dart';
import 'home.dart';

///这些定义只能写在 main.dart 中
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///sharing data
  Muffin.instance.initShare([BasicInfo.instance]);
  Muffin.instance.onMockFunc = (String key, dynamic value) {
    return '';
  };
  runApp(await getApp());

  dynamic mockFuc(String key, [dynamic value]) {
    return '';
  }
}

///get a App with dif initialRoute
Future<Widget> getApp() async {
  final navigator = MuffinNavigator(routes: {
    '/home': (arguments) => MuffinRoutePage(child: HomeScreen()),
    '/first': (arguments) => MuffinRoutePage(
            child: FirstScreen(
          arguments: arguments,
        ))
  }, multiple: true);
  return MaterialApp.router(
    routeInformationParser: MuffinInformationParser(navigator: navigator),
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
