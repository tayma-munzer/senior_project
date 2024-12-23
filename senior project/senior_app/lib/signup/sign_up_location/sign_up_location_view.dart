import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/signup/sign_up_choices/sign_up_choices_controller.dart';
import 'package:senior_app/signup/sign_up_personal_information/sign_up_personal_information_controller.dart';
import 'package:senior_app/widgets/custom_textfield.dart';
import 'sign_up_location_controller.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/colors.dart';

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton<String>(
                      value: controller.selectedCountry,
                      items: <String>['سوريا', 'مصر', 'الأردن', 'لبنان']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        controller.selectedCountry = newValue!;
                      },
                    ),
                    CustomText(
                      text: "الموقع الحالي",
                      fontSize: 20,
                      alignment: Alignment.topRight,
                    ),
                    SizedBox(
                        width: 10), // Add some space between text and dropdown
                  ],
                ),
                SizedBox(height: 20),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      CustomText(
                        text: "تاريخ الميلاد",
                        color: Colors.black,
                        alignment: Alignment.center,
                      ),
                      CustomTextFormField(
                        hint: 'يوم/شهر/سنة',
                        validator: controller.validateBirthDate,
                        onSave: (value) => controller.birthDate = value!,
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        text: 'تأكيد',
                        onPressed: () {
                          controller.saveLocation();
                          print(
                              'Selected role: ${choiceController.selectedChoice.value}');
                          print(
                              ' first name: ${personalInformationController.firstName.value}');
                          print(
                              ' last name: ${personalInformationController.lastName.value}');
                          print(
                              ' phone number: ${personalInformationController.phoneNumber.value}');
                          print(
                              ' land line number: ${personalInformationController.landlineNumber.value}');

                          // Check user role and navigate accordingly
                          if (choiceController.selectedChoice.value == 'ممثل') {
                            // Corrected from 'actor' to 'ممثل'
                            Get.toNamed('/signupactingtypes');
                          } else {
                            Get.toNamed('/login');
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
