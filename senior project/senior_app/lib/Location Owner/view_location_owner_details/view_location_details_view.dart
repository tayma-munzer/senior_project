import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Location%20Owner/view_location_owner_details/view_location_details_controller.dart';
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
                const SizedBox(height: 20),
                CustomText(
                  text: location['location'] ?? 'Unknown Location',
                  fontSize: 24,
                  color: Colors.black,
                  alignment: Alignment.centerRight,
                ),
                const SizedBox(height: 10),
                CustomText(
                  text:
                      '${location['detailed_address'] ?? 'No Address'} : تفاصيل العنوان',
                  fontSize: 20,
                  color: Colors.grey,
                  alignment: Alignment.centerRight,
                ),
                const SizedBox(height: 10),
                CustomText(
                  text: ' ${location['desc'] ?? 'No Description'} :  الوصف',
                  fontSize: 20,
                  color: Colors.grey,
                  alignment: Alignment.centerRight,
                ),
                const SizedBox(height: 10),
                CustomText(
                  text:
                      ' ${location['building_style'] != null ? location['building_style']['building_style'] : 'Unknown'} : نمط البناء',
                  fontSize: 20,
                  color: Colors.blue,
                  alignment: Alignment.centerRight,
                ),
                const SizedBox(height: 10),
                CustomText(
                  text:
                      ' ${location['building_type'] != null ? location['building_type']['building_type'] : 'Unknown'} :  نوع البناء',
                  fontSize: 20,
                  color: Colors.green,
                  alignment: Alignment.centerRight,
                ),
                const SizedBox(height: 20),
                if (videoUrl.isNotEmpty) ...[
                  CustomText(text: 'Video:', fontSize: 18, color: Colors.black),
                  const SizedBox(height: 10),
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
        child: const Icon(Icons.build),
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
              const SizedBox(width: 10),
              const Text('تعديل الموقع'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              const SizedBox(width: 10),
              const Text('حذف الموقع'),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    );

    if (result == 'edit') {
      Get.toNamed(
        '/editlocationowner',
        arguments: {
          'locationId': locationId,
          'locationDetails': controller.locationDetails.value,
        },
      );
    } else if (result == 'delete') {
      if (locationId != 0) {
        await _showDeleteConfirmationDialog(context, controller, locationId);
      } else {
        Get.snackbar('Error', 'Invalid location ID');
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context,
      ViewLocationOwnerLocationDetailsController controller,
      int locationId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد من حذف هذا الموقع؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await controller.deleteLocation(locationId);
              },
              child: const Text('حذف', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
