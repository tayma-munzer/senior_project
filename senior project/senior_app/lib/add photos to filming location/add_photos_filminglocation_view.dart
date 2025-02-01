import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'add_photos_filminglocation_controller.dart';

class AddPhotoFilmingLocationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPhotoFilmingLocationController>();

    return Scaffold(
      appBar: AppBar(title: Text("إضافة صور للموقع التصويري")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: controller.pickImages,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(() => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.selectedImages.map((image) {
                    return Stack(
                      children: [
                        Image.file(
                          image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () =>
                                controller.selectedImages.remove(image),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                )),
            SizedBox(height: 20),
            CustomButton(
              text: 'التالي',
              onPressed: () => controller.uploadImages(1),
            ),
          ],
        ),
      ),
    );
  }
}
