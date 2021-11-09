import 'package:flutter/material.dart';
import 'package:muffin/core/muffin_main.dart';
import 'package:muffin/navigator/muffin_navigator.dart';
import 'package:muffin_example/basic_info.dart';
import 'package:provider/provider.dart';

import 'package:muffin/muffin.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 50)),
            Text('Home Screen'),
            TextButton(
                onPressed: () async {
                  /* var response = await Muffin.routerDelegate
                      .pushNamed('/first', 'data from home screen');
                  print(response);*/
                  await Muffin.toNamed('/first');
                },
                child: Text('To First Screen')),
            TextButton(
                onPressed: () async {
                  /*MuffinNavigator.of(context)
                      .pop({'data': "data from Home Screen"});*/
                },
                child: Text('pop with result')),
            TextButton(
                onPressed: () async {
                  /* MuffinNavigator.of(context).pushNamed(
                      '/native_second', {'data': "data from Home Screen"});*/
                },
                child: Text('pushNamed Native second')),
            ChangeNotifierProvider.value(
              value: BasicInfo.instance,
              child: Consumer<BasicInfo>(
                builder: (context, info, child) {
                  return Text('${info.isBindTbk} && ${info.userId}');
                },
              ),
            ),
            TextButton(
                onPressed: () {
                  BasicInfo.instance.userId = 'newFlutterUserId';
                },
                child: Text('change BasicInfo in flutter'))
          ],
        ),
      ),
    );
  }
}
