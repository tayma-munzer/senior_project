import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Director/add_artwork/add_artwork_poster_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottomappbar_actor.dart';
import 'package:senior_app/widgets/custom_drawer.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_textfield.dart';

class AddArtworkPosterView extends StatelessWidget {
  final AddArtworkPosterController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            CustomText(
              text: "اسم العمل الفني",
              alignment: Alignment.centerRight,
              fontSize: 20,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hint: "أدخل اسم العمل الفني",
              onChanged: (value) => controller.titleController.text = value,
            ),
            SizedBox(height: 20),
            CustomText(
              text: "ادخل صورة للعمل الفني",
              alignment: Alignment.centerRight,
              fontSize: 20,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Obx(() => controller.selectedImage.value != null
                      ? Image.file(controller.selectedImage.value!, height: 150)
                      : Icon(Icons.camera_alt, size: 50)),
                ),
              ],
            ),
            SizedBox(height: 20),
            CustomButton(
              text: "التالي",
              onPressed: () async {
                final artworkId = await controller.uploadArtwork();
                if (artworkId != null) {
                  Get.toNamed('/addactorstoartwork', arguments: artworkId);
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
