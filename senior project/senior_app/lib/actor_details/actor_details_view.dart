import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/actor_details/actor_details_controller.dart';
import 'package:senior_app/view_actors/view_actors_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_drawer.dart';
import 'package:senior_app/widgets/custom_button.dart';

class ActorDetailsView extends StatelessWidget {
  final ActorDetailsController controller = Get.find();
  final ViewActorsController actorsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final mediaList = controller.actor['images'] ?? [];
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
                    alignment: Alignment.centerRight,
                    child: Text(
                      controller.actor['name'] ?? 'Unknown',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  )),
              SizedBox(height: 8),
              Obx(() => Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      " ${controller.actor['age'] ?? 'Not Available'}: العمر",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
              SizedBox(height: 10),
              Obx(() => Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "  نوع التمثيل:${controller.actor['acting_type'] ?? 'Not Available'}",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
              SizedBox(height: 20),
              Center(
                child: CustomButton(
                  text: "اختيار",
                  onPressed: () {
                    actorsController.toggleActorSelection(controller.actor);
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
