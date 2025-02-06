import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/view_location_owner_details/view_location_details_controller.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_appbar_location.dart';
import 'package:senior_app/widgets/custom_location_bottombar.dart';

class ViewLocationOwnerLocationDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ViewLocationOwnerLocationDetailsController>();

    return Scaffold(
      appBar: CustomAppBarLocation(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final location = controller.locationDetails.value;
        if (location == null || location.isEmpty) {
          return Center(child: CustomText(text: "No details available"));
        }

        final buildingOwner = location['building_owner'] ?? {};
        final photos = controller.photos;
        final videoUrl = location['video'] ?? '';

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (photos.isNotEmpty) ...[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Image.network(
                          "http://10.0.2.2:8000${photos[controller.currentIndex.value]}",
                          fit: BoxFit.cover,
                          width: 300,
                          height: 200,
                        ),
                      ),
                      Positioned(
                        left: -10,
                        top: 70,
                        child: IconButton(
                          icon: Icon(Icons.arrow_left,
                              color: Colors.black, size: 60),
                          onPressed: () => controller.changeImage(-1),
                        ),
                      ),
                      Positioned(
                        right: -10,
                        top: 70,
                        child: IconButton(
                          icon: Icon(Icons.arrow_right,
                              color: Colors.black, size: 60),
                          onPressed: () => controller.changeImage(1),
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 20),
                CustomText(
                  text: location['location'] ?? 'Unknown Location',
                  fontSize: 24,
                  color: Colors.black,
                  alignment: Alignment.centerRight,
                ),
                SizedBox(height: 10),
                CustomText(
                  text:
                      '${location['detailed_address'] ?? 'No Address'} : تفاصيل العنوان',
                  fontSize: 20,
                  color: Colors.grey,
                  alignment: Alignment.centerRight,
                ),
                SizedBox(height: 10),
                CustomText(
                  text:
                      'Description: ${location['desc'] ?? 'No Description'} :  الوصف',
                  fontSize: 20,
                  color: Colors.grey,
                  alignment: Alignment.centerRight,
                ),
                SizedBox(height: 10),
                CustomText(
                  text:
                      ' ${location['building_style']['building_style'] ?? 'Unknown'} : نمط البناء',
                  fontSize: 20,
                  color: Colors.blue,
                  alignment: Alignment.centerRight,
                ),
                SizedBox(height: 10),
                CustomText(
                  text:
                      ' ${location['building_type']['building_type'] ?? 'Unknown'} :  نوع البناء',
                  fontSize: 20,
                  color: Colors.green,
                  alignment: Alignment.centerRight,
                ),
                SizedBox(height: 20),
                if (videoUrl.isNotEmpty) ...[
                  CustomText(text: 'Video:', fontSize: 18, color: Colors.black),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.black,
                    child: Center(
                      child: CustomText(text: 'video Placeholder'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: CustomBottomLocationNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPopupMenu(context);
        },
        child: Icon(Icons.build),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showPopupMenu(BuildContext context) async {
    final controller = Get.find<ViewLocationOwnerLocationDetailsController>();
    final locationId = Get.arguments['locationId'] ?? 0;

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 100,
        MediaQuery.of(context).size.height - 150,
        0,
        0,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 10),
              Text('تعديل الموقع'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 10),
              Text('حذف الموقع'),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    );

    if (result == 'edit') {
      Get.toNamed('/editlocationowner');
    } else if (result == 'delete') {
      if (locationId != 0) {
        await _showDeleteConfirmationDialog(context, controller, locationId);
      } else {
        Get.snackbar('Error', 'Invalid location ID');
      }
    }
  }

  // Method to show the delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(
      BuildContext context,
      ViewLocationOwnerLocationDetailsController controller,
      int locationId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد من حذف هذا الموقع؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await controller.deleteLocation(locationId);
              },
              child: Text('حذف', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
