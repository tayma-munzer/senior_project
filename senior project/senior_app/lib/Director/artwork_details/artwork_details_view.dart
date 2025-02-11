import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_textfield.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'artwork_details_controller.dart';

class ArtworkDetailsView extends StatelessWidget {
  ArtworkDetailsView({Key? key}) : super(key: key) {
    // Remove any existing instance of ArtworkDetailsController.
    if (Get.isRegistered<ArtworkDetailsController>()) {
      Get.delete<ArtworkDetailsController>();
    }
    // Register a factory that will create a new instance each time.
    Get.create<ArtworkDetailsController>(() => ArtworkDetailsController());
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the controller instance.
    final ArtworkDetailsController controller =
        Get.find<ArtworkDetailsController>();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Obx(() => CustomText(
                    text: controller.artworkTitle.value,
                    fontSize: 25,
                    color: Colors.black,
                    alignment: Alignment.center,
                  )),
              SizedBox(height: 20),

              /// **Actors Section**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Get.toNamed('/addactors');
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
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return Column(
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
                                  text: "${actor.firstName} ${actor.lastName}",
                                  fontSize: 16,
                                  alignment: Alignment.centerRight,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
              SizedBox(height: 20),

              /// **Scenes Section**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Get.toNamed('/addlocationtoartwork',
                          arguments: {'artworkId': controller.artworkId});
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
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: controller.scenes.map((scene) {
                    return Card(
                      color: Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          text: scene.title,
                          fontSize: 16,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
