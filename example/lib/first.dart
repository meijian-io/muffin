import 'package:flutter/material.dart';
import 'package:muffin/core/muffin_main.dart';
import 'package:muffin/muffin.dart';

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
                '${Muffin.arguments}',
                style: Theme.of(context).textTheme.headline4,
              ),
              TextButton(
                  onPressed: () {
                    Muffin.pop({'data': 'response from first screen'});
                  },
                  child: Text('back with data')),
              TextButton(
                  onPressed: () {
                    /*MuffinNavigator.of(context).pushNamed(
                        "/main", {'data': 'response from first screen'});*/
                    Navigator.of(context).pop();
                  },
                  child: Text('push native main'))
            ],
          ),
        ),
      ),
    );
  }
}
