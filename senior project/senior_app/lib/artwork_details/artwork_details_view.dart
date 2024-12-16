import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'artwork_details_controller.dart';

class ArtworkDetailsView extends StatelessWidget {
  final ArtworkDetailsController controller =
      Get.find<ArtworkDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              CustomText(
                text: "عنوان العمل الفني",
                fontSize: 25,
                color: Colors.black,
                alignment: Alignment.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Get.toNamed(
                          '/addscene'); // This should trigger the binding and load AddSceneView.
                    },
                  ),
                  CustomText(
                    text: "الممثلين",
                    fontSize: 18,
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() => Column(
                    children: controller.actors.map((actor) {
                      return Card(
                        color: darkgray,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: primaryColor),
                                onPressed: () {
                                  controller.deleteActor(actor);
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomText(
                                    text: actor.name,
                                    fontSize: 16,
                                    alignment: Alignment.centerRight,
                                  ),
                                  CustomText(
                                    text: actor.role,
                                    fontSize: 14,
                                    alignment: Alignment.centerRight,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Get.toNamed('/hhh');
                    },
                  ),
                  CustomText(
                    text: "المشاهد",
                    fontSize: 18,
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() => Column(
                    children: controller.scenes.map((scene) {
                      return Card(
                        color: lightblue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon:
                                        Icon(Icons.delete, color: primaryColor),
                                    onPressed: () {
                                      controller.deleteScene(scene);
                                    },
                                  ),
                                  CustomText(
                                    text: scene.title,
                                    fontSize: 16,
                                    alignment: Alignment.centerRight,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: scene.isFinished
                                        ? "منتهي"
                                        : "غير منتهي",
                                    fontSize: 14,
                                    color: scene.isFinished
                                        ? Colors.green
                                        : Colors.red,
                                    alignment: Alignment.centerRight,
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        text: scene.description,
                                        fontSize: 14,
                                        alignment: Alignment.centerRight,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
