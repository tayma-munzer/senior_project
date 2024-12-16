import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_textfield.dart';
import 'add_scene_controller.dart';

class AddSceneView extends StatelessWidget {
  final AddSceneController controller = Get.find<AddSceneController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'اسم المشهد',
              fontSize: 20,
              alignment: Alignment.bottomRight,
            ),
            CustomTextFormField(
              hint: "أدخل اسم المشهد",
              onSave: (value) {
                controller.sceneName.value = value ?? "";
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.addActor();
                  },
                  child: Icon(
                    Icons.add_circle,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
                CustomText(
                  text: "ممثلين هذا المشهد",
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.actors.length,
                    itemBuilder: (context, index) {
                      final actor = controller.actors[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: controller.selectedActors[index],
                                onChanged: (value) {
                                  controller.toggleSelection(
                                      index, value ?? false);
                                },
                              ),
                              SizedBox(width: 5),
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: AssetImage(
                                    actor['image'] ?? 'assets/login.png'),
                              ),
                            ],
                          ),
                          title: CustomText(
                            text: actor['name'] ?? 'اسم غير متوفر',
                            fontSize: 16,
                            color: Colors.black,
                            alignment: Alignment.bottomRight,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "العمر: ${actor['age']}",
                                fontSize: 14,
                                color: Colors.grey,
                                alignment: Alignment.bottomRight,
                              ),
                              CustomText(
                                text: " ${actor['type']} : نوع التمثيل",
                                fontSize: 14,
                                color: Colors.grey,
                                alignment: Alignment.bottomRight,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ),
            SizedBox(height: 10),
            CustomButton(
              text: "التالي",
              onPressed: () {
                controller.submitScene();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
