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
  final ArtworkDetailsController controller =
      Get.put(ArtworkDetailsController());

  final List<String> hardcodedScenes = [
    "المشهد الأول: لقاء البطل والبطلة",
    "المشهد الثاني: المواجهة الحاسمة",
    "المشهد الثالث: النهاية الغامضة",
  ];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {},
                  ),
                  CustomText(
                    text: "المشاهد",
                    fontSize: 18,
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: hardcodedScenes.map((scene) {
                  return Card(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                        text: scene,
                        fontSize: 16,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
