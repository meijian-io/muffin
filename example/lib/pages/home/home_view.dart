import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muffin_example/pages/home/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        child: Container(
          height: 50,
          child: TextButton(
            onPressed: () {
              Get.rootDelegate.toNamed('/native/home');
            },
            child: Text(
              'To countrys',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
