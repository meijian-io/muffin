import 'package:flutter/material.dart';
import 'package:muffin/muffin.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('second page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is page',
            ),
            Text(
              'second',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '${Muffin.arguments}',
              style: Theme.of(context).textTheme.headline4,
            )
          ],
        ),
      ),
    );
  }
}
