import 'package:flutter/material.dart';
import 'package:muffin/core/muffin_main.dart';
import 'package:muffin_example/basic_info.dart';
import 'package:muffin_example/utils/toast.dart';
import 'package:provider/provider.dart';

import 'package:muffin/muffin.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page ${Muffin.currentRouteName}'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 50)),
            TextButton(
                onPressed: () async {
                  var response = await Muffin.pushNamed('/home/first',
                      arguments: 'data from home screen');
                  ToastUtils.showToast(response.toString());
                },
                child: Text('To First Screen, Get Response')),
            TextButton(
                onPressed: () async {
                  //这种类型在移动端应该很少用，在web端可以用到，
                  //因为参数通过url传递在移动端没有参数来的直接
                  await Muffin.pushNamed('/home/second/111',
                      arguments: 'data from home screen to second screen');
                },
                child: Text('To Second Screen')),
            TextButton(
                onPressed: () async {
                  await Muffin.pushNamed('/native_second',
                      arguments: {'data': "data from Home Screen"});
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
                child: Text('change BasicInfo in flutter')),
            TextButton(
                onPressed: () {
                  Muffin.pop({'data': 'Response from Home Screen'});
                },
                child: Text('back with data'))
          ],
        ),
      ),
    );
  }
}
