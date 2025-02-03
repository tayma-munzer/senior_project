import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome Page")),
      body: Center(
        child: Obx(() => Text(
              controller.welcomeMessage.value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
