import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muffin/navigator/information_parser.dart';
import 'package:muffin/navigator/page_route.dart';
import 'package:muffin/root/muffin_material_app.dart';

import 'package:muffin_example/basic_info.dart';
import 'package:muffin_example/second.dart';

import 'first.dart';
import 'home.dart';
import 'package:muffin/muffin.dart';

///这些定义只能写在 main.dart 中
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///sharing data
  Muffin.initShare([BasicInfo.instance]);
  // 添加自定义 mock 数据
  Muffin.addMock(MockConfig('getArguments', (key, value) => {}));
  runApp(await getApp());
}

///get a App with dif initialRoute
Future<Widget> getApp() async {
  var arguments = await NavigatorChannel.arguments;
  print(arguments);

  return MuffinMaterialApp(
      routeInformationParser: MuffinInformationParser(
          initialRoute: arguments?['url'], arguments: arguments?['arguments']),
      muffinPages: [
        /// /home/first and /home/second
        MuffinPage(name: '/home', page: () => HomeScreen(), children: [
          MuffinPage(
            name: '/first',
            page: () => FirstScreen(),
          ),
          MuffinPage(name: '/second/:id', page: () => SecondScreen()),
        ])
      ]);
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
