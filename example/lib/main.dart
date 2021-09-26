import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:muffin/muffin.dart';
import 'package:muffin_example/basic_info.dart';
import 'package:muffin_example/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';

///这些定义只能写在 main.dart 中
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///sharing data
  Muffin.instance.initShare([BasicInfo.instance]);
  // 添加自定义 mock 数据
  // Muffin.instance.addMock(MockConfig('getArguments', (key, value) => {}));

  runApp(await getApp());
}

///get a App with dif initialRoute
Future<Widget> getApp() async {
  return GetMaterialApp.router(
    debugShowCheckedModeBanner: false,
    enableLog: true,
    getPages: AppPages.routes,
    routeInformationParser: GetInformationParser(initialRoute: '/home'),
    routerObserver: MyRouterObserver(),
  );
}

class MyRouterObserver extends RouterObserver {
  @override
  Future<T> push<T>(RouteDecoder decoder) {
    Get.log('Muffin handle this push ${decoder.treeBranch}');
    return Future.value();
  }
}
