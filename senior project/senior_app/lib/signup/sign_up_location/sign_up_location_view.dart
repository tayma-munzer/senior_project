import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/signup/sign_up/sign_up_controller.dart';
import 'package:senior_app/signup/sign_up_choices/sign_up_choices_controller.dart';
import 'package:senior_app/signup/sign_up_personal_information/sign_up_personal_information_controller.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/colors.dart';
import 'sign_up_location_controller.dart';

class SignUpLocationView extends StatelessWidget {
  final SignUpLocationController controller =
      Get.put(SignUpLocationController());
  final SignUpChoicesController choiceController =
      Get.find<SignUpChoicesController>();
  final SignUpPersonalInformationController personalInformationController =
      Get.find<SignUpPersonalInformationController>();

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
                Image.asset(
                  'assets/location.webp',
                  width: 300,
                ),
                SizedBox(height: 20),
                Obx(() {
                  if (controller.countries.isEmpty) {
                    return CircularProgressIndicator();
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton<String>(
                          value: controller.selectedCountry.value,
                          items: controller.countries
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            controller.selectedCountry.value = newValue!;
                          },
                        ),
                        CustomText(
                          text: "الموقع الحالي",
                          fontSize: 20,
                          alignment: Alignment.topRight,
                        ),
                        SizedBox(width: 10),
                      ],
                    );
                  }
                }),
                SizedBox(height: 20),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      CustomText(
                        text: "تاريخ الميلاد",
                        color: Colors.black,
                        alignment: Alignment.topRight,
                        fontSize: 20,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        textAlign: TextAlign.end,
                        controller: controller.birthDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'يوم/شهر/سنة',
                          suffixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onTap: () => controller.selectBirthDate(context),
                        validator: (value) =>
                            controller.validateBirthDate(value),
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        text: 'تأكيد',
                        onPressed: () {
                          controller.saveLocation();
                          if (choiceController.selectedChoice.value == 'ممثل') {
                            Get.toNamed('/signupactingtypes');
                          } else {
                            Get.find<SignUpController>().registerUser();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
