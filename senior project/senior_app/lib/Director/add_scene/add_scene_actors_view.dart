import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'add_scene_actors_controller.dart';
import 'package:senior_app/widgets/custom_textfield.dart';

class AddSceneActorsView extends StatelessWidget {
  final AddSceneActorsController controller =
      Get.find<AddSceneActorsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    size: 32,
                  ),
                ),
                CustomText(
                  text: "ممثلين هذا المشهد",
                  fontSize: 18,
                  color: Colors.grey.shade800,
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.actors.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: controller.actors.length,
                  itemBuilder: (context, index) {
                    final actor = controller.actors[index];
                    return Card(
                      elevation: 6,
                      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: Row(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(() {
                                  return Checkbox(
                                    value: controller.selectedActors[index],
                                    onChanged: (value) {
                                      controller.toggleSelection(
                                          index, value ?? false);
                                    },
                                  );
                                }),
                                SizedBox(width: 8),
                                CircleAvatar(
                                  radius: 36,
                                  backgroundImage: actor['image'] != null &&
                                          actor['image']
                                              .toString()
                                              .startsWith('http')
                                      ? NetworkImage(actor['image'])
                                      : AssetImage(actor['image'] ??
                                          'assets/login.png') as ImageProvider,
                                ),
                              ],
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: actor['name'] ?? 'اسم غير متوفر',
                                    fontSize: 18,
                                    color: Colors.black,
                                    alignment: Alignment.bottomRight,
                                  ),
                                  SizedBox(height: 8),
                                  CustomText(
                                    text: "العمر: ${actor['age']}",
                                    fontSize: 16,
                                    color: Colors.grey,
                                    alignment: Alignment.bottomRight,
                                  ),
                                  CustomText(
                                    text: " ${actor['type']} : نوع التمثيل",
                                    fontSize: 16,
                                    color: Colors.grey,
                                    alignment: Alignment.bottomRight,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 16),
            CustomButton(
              text: "التالي",
              onPressed: () {
                controller.submitScene();
                Get.toNamed('/addlocation');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
