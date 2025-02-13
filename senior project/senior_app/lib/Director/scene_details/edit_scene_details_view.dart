import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditSceneDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};

    return Scaffold(
      appBar: AppBar(title: Text('Edit Scene Details')),
      body: Center(
        child: Text('Editing Scene: ${args['scene_id'] ?? "Unknown"}'),
      ),
    );
  }
}
