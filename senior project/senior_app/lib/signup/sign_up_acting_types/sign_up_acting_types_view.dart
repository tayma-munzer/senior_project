import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/signup/sign_up/sign_up_controller.dart';
import 'sign_up_acting_type_controller.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_text.dart';

class SignUpActingTypeView extends StatelessWidget {
  final SignUpActingTypeController controller =
      Get.put(SignUpActingTypeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset('assets/topbluecorner.png', width: 100),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset('assets/bottompinkcorner.png', width: 100),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/acting.png', width: 300),
                SizedBox(height: 20),
                CustomText(
                  text: "اختر انواع التمثيل المفضلة لديك",
                  alignment: Alignment.centerRight,
                  fontSize: 20,
                ),
                SizedBox(height: 20),
                Obx(() {
                  if (controller.actingTypes.isEmpty) {
                    return CircularProgressIndicator();
                  } else {
                    return DropdownButton<String>(
                      value: controller.selectedActingType.value.isEmpty
                          ? null
                          : controller.selectedActingType.value,
                      hint: Text("  انواع التمثيل"),
                      items: controller.actingTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              value,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.saveActingType(newValue);
                          controller.selectedActingType.value = newValue;
                        }
                      },
                    );
                  }
                }),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "انواع التمثيل المختارة",
                      fontSize: 25,
                      color: primaryColor,
                    )
                  ],
                ),
                SizedBox(height: 20),
                Obx(() {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: controller.savedActingTypes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Align(
                            alignment: Alignment.centerRight,
                            child: Text(controller.savedActingTypes[index]),
                          ),
                          leading: IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              controller.removeActingType(
                                  controller.savedActingTypes[index]);
                            },
                          ),
                        );
                      },
                    ),
                  );
                }),
                SizedBox(height: 20),
                CustomButton(
                  text: 'تأكيد',
                  onPressed: () {
                    if (controller.savedActingTypes.isNotEmpty) {
                      Get.find<SignUpController>()
                          .registerUser(); // Call registerUser
                    } else {
                      Get.snackbar(
                        "خطا",
                        "يجب اختيار نوع تمثيل واحد على الاقل",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(10),
                        snackStyle: SnackStyle.FLOATING,
                        titleText: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "خطا",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        messageText: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "يجب اختيار نوع تمثيل واحد على الاقل",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
