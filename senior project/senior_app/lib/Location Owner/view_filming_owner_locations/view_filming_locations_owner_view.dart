import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar_location.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_location_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'view_filming_locations_owner_controller.dart';

class ViewOwnerFilmingLocationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ViewOwnerFilmingLocationController>();

    return Scaffold(
      appBar: CustomAppBarLocation(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.locations.isEmpty) {
          return Center(child: CustomText(text: "لا توجد مواقع حالياً"));
        }
        return ListView.builder(
          itemCount: controller.locations.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Image.asset(
                'assets/houses.png',
                width: double.infinity,
                height: 250,
              );
            }

            final location = controller.locations[index - 1];

            final locationId = location['id'] ?? 0;
            final locationName = location['location'] ?? 'Unknown Location';
            final detailedAddress =
                location['detailed_address'] ?? 'No Address';
            final buildingStyle = location['building_style']
                    ?['building_style'] ??
                'Unknown Style';
            final buildingType =
                location['building_type']?['building_type'] ?? 'Unknown Type';
            final photoPath = location['photo'] ?? '';
            final photoUrl =
                photoPath.isNotEmpty ? "http://10.0.2.2:8000$photoPath" : null;

            return GestureDetector(
              onTap: () {
                if (locationId != 0) {
                  print(
                      'Navigating to ViewLocationOwnerLocationDetailsView with locationId: $locationId');
                  Get.toNamed(
                    '/locationownerdetails',
                    arguments: {'locationId': locationId},
                  );
                } else {
                  print('Invalid location ID');
                }
              },
              child: Card(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                        image: photoUrl != null
                            ? DecorationImage(
                                image: NetworkImage(photoUrl),
                                fit: BoxFit.fill,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        color: photoUrl == null ? Colors.grey[300] : null,
                      ),
                      child: photoUrl == null
                          ? Icon(Icons.image, size: 50, color: Colors.grey)
                          : null,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            CustomText(
                              text: locationName,
                              fontSize: 20,
                              color: Colors.black,
                              alignment: Alignment.centerRight,
                            ),
                            SizedBox(height: 5),
                            CustomText(
                              text: detailedAddress,
                              fontSize: 16,
                              color: Colors.grey,
                              alignment: Alignment.centerRight,
                            ),
                            CustomText(
                              text: "$buildingStyle  : نمط البناء'",
                              fontSize: 16,
                              color: Colors.blue,
                              alignment: Alignment.centerRight,
                            ),
                            CustomText(
                              text: "$buildingType  :  نوع البناء'",
                              fontSize: 16,
                              color: Colors.green,
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
