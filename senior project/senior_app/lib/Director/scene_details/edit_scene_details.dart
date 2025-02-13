import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:senior_app/Director/scene_details/scene_details_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_text.dart';

class EditSceneDetails extends StatelessWidget {
  EditSceneDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SceneDetailsController controller =
        Get.find<SceneDetailsController>();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "عنوان المشهد", fontSize: 20),
            TextField(
              controller:
                  TextEditingController(text: controller.editedTitle.value),
              onChanged: (value) {
                controller.editedTitle.value = value;
              },
            ),
            SizedBox(height: 20),
            CustomText(text: "تاريخ البدء", fontSize: 20),
            TextField(
              controller:
                  TextEditingController(text: controller.editedStartDate.value),
              onChanged: (value) {
                controller.editedStartDate.value = value;
              },
            ),
            SizedBox(height: 20),
            CustomText(text: "تاريخ الانتهاء", fontSize: 20),
            TextField(
              controller:
                  TextEditingController(text: controller.editedEndDate.value),
              onChanged: (value) {
                controller.editedEndDate.value = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.updateSceneDetails,
              child: Text("حفظ"),
            ),
          ],
        ),
      ),
    );
  }
}
