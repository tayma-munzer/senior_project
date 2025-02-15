import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_textfield.dart';
import 'add_location_controller.dart';

class AddLocationView extends StatelessWidget {
  final AddLocationController controller = Get.find<AddLocationController>();

  @override
  Widget build(BuildContext context) {
    final int artworkId = Get.arguments['artworkId'];

    controller.fetchLocations();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(),
            SizedBox(height: 20),
            CustomText(
              text: "اسم المشهد",
              fontSize: 20,
              alignment: Alignment.bottomRight,
            ),
            SizedBox(height: 8),
            CustomTextFormField(
              hint: "ادخل اسم المشهد",
              onChanged: (value) {
                controller.sceneName.value = value;
              },
            ),
            SizedBox(height: 20),
            CustomText(
              text: "اختر موقع تمثيل",
              fontSize: 20,
              alignment: Alignment.bottomRight,
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.locations.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: controller.locations.length,
                    itemBuilder: (context, index) {
                      final location = controller.locations[index];
                      return GestureDetector(
                        onTap: () {
                          controller.selectLocation(index);
                        },
                        child: Obx(() {
                          final isSelected =
                              controller.selectedLocationIndex.value == index;
                          return Card(
                            elevation: 6,
                            margin: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected ? Colors.blue : Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          'http://10.0.2.2:8000${location['photo']}',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: location['location'] ??
                                              'اسم غير متوفر',
                                          fontSize: 18,
                                          color: Colors.black,
                                          alignment: Alignment.bottomRight,
                                        ),
                                        SizedBox(height: 8),
                                        CustomText(
                                          text:
                                              "العنوان: ${location['detailed_address'] ?? ''}",
                                          fontSize: 16,
                                          color: Colors.grey,
                                          alignment: Alignment.bottomRight,
                                        ),
                                        CustomText(
                                          text:
                                              " ${location['building_style']} : نمط البناء",
                                          fontSize: 16,
                                          color: Colors.grey,
                                          alignment: Alignment.bottomRight,
                                        ),
                                        CustomText(
                                          text:
                                              " ${location['building_type']} : نوع البناء",
                                          fontSize: 16,
                                          color: Colors.grey,
                                          alignment: Alignment.bottomRight,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  );
                }
              }),
            ),
            SizedBox(height: 16),
            CustomButton(
              text: "التالي",
              onPressed: () {
                controller.submitLocation();

                if (controller.selectedLocationIndex.value >= 0) {
                  var selectedLocation = controller
                      .locations[controller.selectedLocationIndex.value];

                  Get.toNamed('/adddays', arguments: {
                    'locationId': selectedLocation['id'],
                    'title': controller.sceneName.value,
                    'artworkId': artworkId,
                  });
                } else {
                  print("No location selected!");
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
