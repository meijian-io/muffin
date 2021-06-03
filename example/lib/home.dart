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
                  MuffinNavigator.of(context).push(Uri(path: '/first'));
                },
                child: Text('To First Screen')),
            TextButton(onPressed: () async {}, child: Text('To First Screen'))
          ],
        ),
      ),
    );
  }
}
