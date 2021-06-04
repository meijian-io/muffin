import 'package:flutter/material.dart';
import 'package:muffin/navigator/muffin_navigator.dart';

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
                  var response = await MuffinNavigator.of(context).pushNamed(
                      Uri(path: '/first'),
                      arguments: 'data from home screen');
                  print(response);
                },
                child: Text('To First Screen')),
            TextButton(onPressed: () async {}, child: Text('To First Screen'))
          ],
        ),
      ),
    );
  }
}
