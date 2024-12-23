import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/location_details/location_details_controller.dart';
import 'package:senior_app/view_locations/view_locations_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_drawer.dart';

class ViewLocationDetailsView extends StatelessWidget {
  final ViewLocationDetailsController controller = Get.find();
  final ViewLocationsController locationsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // Align to the right
            children: [
              Obx(() {
                final mediaList = controller.location['images'] ?? [];
                if (mediaList.isEmpty) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/login.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    Container(
                      height: 200,
                      child: PageView.builder(
                        controller: controller.pageController,
                        itemCount: mediaList.length,
                        itemBuilder: (context, index) {
                          final media = mediaList[index];
                          if (media.endsWith('.mp4')) {
                            return Center(
                              child: Icon(
                                Icons.videocam,
                                size: 100,
                                color: Colors.grey,
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage(media),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: controller.previousPage,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: controller.nextPage,
                        ),
                      ],
                    ),
                  ],
                );
              }),
              SizedBox(height: 16),
              Obx(() => Align(
                    alignment: Alignment.centerRight, // Align text to the right
                    child: Text(
                      controller.location['name'] ?? 'Unknown',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  )),
              SizedBox(height: 8),
              Obx(() => Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Building Style: ${controller.location['building_style'] ?? 'Unknown'}",
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
              SizedBox(height: 8),
              Obx(() => Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Owner: ${controller.location['owner'] ?? 'Unknown'}",
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
              SizedBox(height: 8),
              Obx(() => Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      controller.location['description'] ??
                          'No description available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )),
              SizedBox(height: 20),
              Center(
                child: CustomButton(
                  text: "اختيار",
                  onPressed: () {
                    locationsController
                        .toggleLocationSelection(controller.location);
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
