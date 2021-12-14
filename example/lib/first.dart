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
          title: Text('First Page ${Muffin.currentRouteName}'),
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
              ),
              TextButton(
                  onPressed: () {
                    Muffin.pop('response from first screen');
                  },
                  child: Text('back with data')),
              TextButton(
                  onPressed: () {
                    Muffin.pop({'response': 'response from first screen'});
                  },
                  child: Text('back with map data')),
              TextButton(
                  onPressed: () {
                    Muffin.pop();
                  },
                  child: Text('back with no data')),
              TextButton(
                  onPressed: () {
                    Muffin.popUntil(
                        'MainActivity', {'data': 'data from first screen'});
                  },
                  child: Text('Pop until Main')),
            ],
          ),
        ),
      ),
    );
  }
}
