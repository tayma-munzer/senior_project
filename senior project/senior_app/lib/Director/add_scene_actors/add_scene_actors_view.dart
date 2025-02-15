import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_drawer.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'add_scene_actors_controller.dart';

class AddSceneActorsView extends StatelessWidget {
  final AddSceneActorsController controller =
      Get.find<AddSceneActorsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
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
                return ListView.builder(
                  itemCount: controller.actors.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(() => Checkbox(
                                  value: controller.selectedActors[index],
                                  onChanged: (bool? value) {
                                    controller.toggleSelection(index, value!);
                                  },
                                )),
                            ClipOval(
                              child: Image.network(
                                controller.actors[index]["image"],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: controller.actors[index]["name"],
                                    fontSize: 16,
                                  ),
                                  CustomText(
                                    text: controller.actors[index]["type"],
                                    fontSize: 14,
                                    color: Colors.grey,
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
            CustomButton(
              text: "التالي",
              onPressed: () {
                controller.submitScene();
                Get.toNamed('/directorHome');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
