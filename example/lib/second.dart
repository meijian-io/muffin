import 'package:flutter/material.dart';
import 'package:muffin/muffin.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        automaticallyImplyLeading: false,
        title: Text('Second Page ${Muffin.currentRouteName}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Get arguments by [Muffin.arguments]',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              '${Muffin.arguments}',
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      ),
    );
  }
}
