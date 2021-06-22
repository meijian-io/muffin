import 'package:flutter/material.dart';
import 'package:muffin/navigator/muffin_navigator.dart';
import 'package:muffin_example/basic_info.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Home Screen'),
            TextButton(
                onPressed: () async {
                  var response = await MuffinNavigator.of(context)
                      .pushNamed(Uri(path: '/first'), 'data from home screen');
                  print(response);
                },
                child: Text('To First Screen')),
            TextButton(
                onPressed: () async {
                  MuffinNavigator.of(context)
                      .pop({'data': "data from Home Screen"});
                },
                child: Text('pop with result')),
            TextButton(
                onPressed: () async {
                  MuffinNavigator.of(context).pushNamed(
                      Uri.parse('/native_second'),
                      {'data': "data from Home Screen"});
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
