import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottomappbar_actor.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_textfield.dart';
import 'chroma_controller.dart';

class ChromaView extends GetView<ChromaController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChromaController());

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: 'اضف شرحا عن المشهد',
                fontSize: 18,
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                hint: 'اكتب هنا...',
                onChanged: (value) => controller.explanation.value = value,
              ),
              SizedBox(height: 20),
              CustomText(
                text: 'اضف صورة',
                fontSize: 18,
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: controller.pickImage,
                  child: Obx(() {
                    return controller.selectedImage.value == null
                        ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                        : Image.file(
                            File(controller.selectedImage.value!.path),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          );
                  }),
                ),
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'توليد',
                onPressed: controller.generateImage,
              ),
              SizedBox(height: 20),
              Obx(() {
                return controller.generatedImageUrl.value.isNotEmpty
                    ? Center(
                        child: Image.network(
                          controller.generatedImageUrl.value,
                          width: 200,
                          height: 200,
                        ),
                      )
                    : Container();
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
