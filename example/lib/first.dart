import 'package:flutter/material.dart';
import 'package:muffin/navigator/muffin_navigator.dart';

class FirstScreen extends StatelessWidget {
  final dynamic arguments;

  const FirstScreen({
    Key? key,
    this.arguments,
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
                '$arguments',
                style: Theme.of(context).textTheme.headline4,
              ),
              TextButton(
                  onPressed: () {
                    MuffinNavigator.of(context)
                        .pop({'data': 'response from first screen'});
                  },
                  child: Text('back with data')),
              TextButton(
                  onPressed: () {
                    MuffinNavigator.of(context).pushNamed(Uri.parse("/main"),
                        {'data': 'response from first screen'});
                  },
                  child: Text('push native main'))
            ],
          ),
        ),
      ),
    );
  }
}
