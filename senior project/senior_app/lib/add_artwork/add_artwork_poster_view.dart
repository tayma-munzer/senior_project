import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/add_artwork/add_artwork_poster_controller.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_textfield.dart';

class AddArtworkPosterView extends StatelessWidget {
  final AddArtworkPosterController controller =
      Get.put(AddArtworkPosterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Add Artwork Poster',
          color: Colors.white,
          fontSize: 20,
          alignment: Alignment.center,
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'اسم العمل الفني',
                fontSize: 18,
                color: Colors.black,
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                hint: 'ادخل اسم العمل الفني',
                onChanged: (value) {
                  controller.nameController.text = value;
                },
              ),
              SizedBox(height: 20),
              CustomText(
                text: 'ادخل صورة للعمل الفني',
                fontSize: 18,
                color: Colors.black,
              ),
              SizedBox(height: 10),
              Obx(() {
                return GestureDetector(
                  onTap: () async {
                    await controller.pickImage();
                  },
                  child: Column(
                    children: [
                      controller.imagePath.value.isEmpty
                          ? Column(
                              children: [
                                Image.asset(
                                  'assets/login.png',
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 10),
                                Text('tap to select an image'),
                                Icon(Icons.camera_alt,
                                    size: 30, color: Colors.grey),
                              ],
                            )
                          : Column(
                              children: [
                                Image.file(
                                  File(controller.imagePath.value),
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 10),
                                Text('Tap to change the image'),
                                Icon(Icons.camera_alt,
                                    size: 30, color: Colors.grey),
                              ],
                            ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 30),
              CustomButton(
                text: 'التالي',
                onPressed: () async {
                  await controller.submitArtwork();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
