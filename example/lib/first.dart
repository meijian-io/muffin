import 'package:flutter/material.dart';

import 'main.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.redAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('First page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'This is page',
              ),
              Text(
                'first',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                'KK',
                style: Theme.of(context).textTheme.headline4,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop('/first');
                  },
                  child: Text('back with data'))
            ],
          ),
        ),
      ),
    );
  }
}
