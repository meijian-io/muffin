import 'package:flutter/material.dart';

import 'main.dart';

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
                  MyRouteDelegate.of(context).push('/first');
                },
                child: Text('To First Screen')),
            TextButton(onPressed: () async {}, child: Text('To First Screen'))
          ],
        ),
      ),
    );
  }
}
