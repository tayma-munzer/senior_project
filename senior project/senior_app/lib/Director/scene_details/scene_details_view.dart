import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'scene_details_controller.dart';

class SceneDetailsView extends StatelessWidget {
  final SceneDetailsController controller = Get.find<SceneDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        var scene = controller.sceneDetails.value;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              CustomText(
                text: "Scene Title: ${scene['title']}",
                fontSize: 18,
                color: Colors.grey.shade800,
              ),
              SizedBox(height: 16),
              CustomText(
                text: "Start Date: ${scene['start_date']}",
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              CustomText(
                text: "End Date: ${scene['end_date']}",
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              CustomText(
                text: "Scene Number: ${scene['scene_number']}",
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 16),
              CustomText(
                text: "Artwork Title: ${scene['artwork']['title']}",
                fontSize: 18,
                color: Colors.grey.shade800,
              ),
              CustomText(
                text:
                    "Director: ${scene['artwork']['director']['first_name']} ${scene['artwork']['director']['last_name']}",
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              CustomText(
                text: "Location: ${scene['location']['location']}",
                fontSize: 18,
                color: Colors.grey.shade800,
              ),
              CustomText(
                text:
                    "Building Style: ${scene['location']['building_style']['building_style']}",
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              CustomText(
                text:
                    "Building Type: ${scene['location']['building_type']['building_type']}",
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 16),
              CustomButton(
                text: "Go Back",
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
