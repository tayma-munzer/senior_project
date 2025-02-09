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
            Text(
              "اضف صورة عن موقعك التصويري",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: controller.pickImage,
              child: Obx(() {
                return Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: controller.selectedImage.value == null
                      ? Center(
                          child: Icon(Icons.add_a_photo,
                              size: 50, color: Colors.grey),
                        )
                      : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                controller.selectedImage.value!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectedImage.value = null;
                                },
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
                        ),
                );
              }),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'التالي',
              onPressed: () => controller.uploadImage(1),
            ),
          ],
        ),
      ),
    );
  }
}
