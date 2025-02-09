import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar_location.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_textfield.dart';
import 'package:senior_app/widgets/custom_button.dart';
import '../../../widgets/custom_location_bottombar.dart';
import 'add_filming_location_controller.dart';

class AddFilmingLocationView extends StatelessWidget {
  final AddFilmingLocationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarLocation(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/addlocation.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              CustomText(text: 'اسم الموقع', alignment: Alignment.topRight),
              CustomTextFormField(
                hint: 'أدخل اسم الموقع',
                onChanged: (value) => controller.location.value = value,
              ),
              Obx(() => Text(
                    controller.locationError.value,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.right,
                  )),
              CustomText(text: 'تفاصيل العنوان', alignment: Alignment.topRight),
              CustomTextFormField(
                hint: 'أدخل تفاصيل العنوان',
                onChanged: (value) => controller.detailedAddress.value = value,
              ),
              Obx(() => Text(
                    controller.addressError.value,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.right,
                  )),
              CustomText(text: 'الوصف', alignment: Alignment.topRight),
              CustomTextFormField(
                hint: 'أدخل الوصف',
                onChanged: (value) => controller.description.value = value,
              ),
              Obx(() => Text(
                    controller.descriptionError.value,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.right,
                  )),
              CustomText(text: 'نمط البناء', alignment: Alignment.topRight),
              Obx(() => Align(
                    alignment: Alignment.centerRight,
                    child: DropdownButton<int>(
                      value: controller.selectedBuildingStyle.value,
                      hint: Text('اختر نمط البناء'),
                      items: controller.buildingStyles.map((style) {
                        return DropdownMenuItem<int>(
                          value: style['id'],
                          child: Text(style['building_style'] ?? 'غير معروف',
                              style: TextStyle(fontSize: 16)),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          controller.selectedBuildingStyle.value = value,
                      isExpanded: false,
                    ),
                  )),
              Obx(() => Text(
                    controller.buildingStyleError.value,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.right,
                  )),
              CustomText(text: 'نوع البناء', alignment: Alignment.topRight),
              Obx(() => Align(
                    alignment: Alignment.centerRight,
                    child: DropdownButton<int>(
                      value: controller.selectedBuildingType.value,
                      hint: Text('اختر نوع البناء'),
                      items: controller.buildingTypes.map((type) {
                        return DropdownMenuItem<int>(
                          value: type['id'],
                          child: Text(type['building_type'] ?? 'غير معروف',
                              style: TextStyle(fontSize: 16)),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          controller.selectedBuildingType.value = value,
                      isExpanded: false,
                    ),
                  )),
              Obx(() => Text(
                    controller.buildingTypeError.value,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.right,
                  )),
              SizedBox(height: 20),
              CustomButton(
                text: 'التالي',
                onPressed: () => controller.submitLocation(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
