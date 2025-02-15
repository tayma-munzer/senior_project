import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/signup/sign_up_personal_information/sign_up_personal_information_controller.dart';
import 'package:senior_app/signup/sign_up_choices/sign_up_choices_controller.dart'; // Import the SignUpChoicesController
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_textfield.dart';

class SignUpPersonalInformationView extends StatelessWidget {
  final controller = Get.find<SignUpPersonalInformationController>();
  final choiceController = Get.find<SignUpChoicesController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/topbluecorner.png',
              width: 110,
              height: 100,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/bottompinkcorner.png',
              width: 150,
              height: 100,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/personalinformation.png',
                      width: 300,
                      height: 300,
                    ),
                    CustomText(
                      text: "الاسم الاول",
                      alignment: Alignment.centerRight,
                      fontSize: 20,
                    ),
                    CustomTextFormField(
                      hint: 'الاسم الاول',
                      onSave: (value) =>
                          controller.firstName.value = value ?? '',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم الاول';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      text: " اسم العائلة",
                      alignment: Alignment.centerRight,
                      fontSize: 20,
                    ),
                    CustomTextFormField(
                      hint: 'اسم العائبة',
                      onSave: (value) =>
                          controller.lastName.value = value ?? '',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال اسم العائبة';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      text: " رقم الهاتف",
                      alignment: Alignment.centerRight,
                      fontSize: 20,
                    ),
                    CustomTextFormField(
                      hint: 'رقم الهاتف',
                      onSave: (value) =>
                          controller.phoneNumber.value = value ?? '',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الهاتف';
                        } else if (!RegExp(r'^09\d{8}$').hasMatch(value)) {
                          return 'رقم الهاتف يجب أن يبدأ بـ 09 ويحتوي على 10 أرقام';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      text: " رقم الهاتف الارضي",
                      alignment: Alignment.centerRight,
                      fontSize: 20,
                    ),
                    CustomTextFormField(
                      hint: 'رقم الهاتف الارضي',
                      onSave: (value) =>
                          controller.landlineNumber.value = value ?? '',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الهاتف الارضي';
                        } else if (!RegExp(r'^011\d{7}$').hasMatch(value)) {
                          return 'رقم الهاتف الارضي يجب أن يبدأ بـ 011 ويحتوي على 10 أرقام';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: 'التالي',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          controller.saveInformation(
                            controller.firstName.value,
                            controller.lastName.value,
                            controller.phoneNumber.value,
                            controller.landlineNumber.value,
                          );

                          final role = choiceController.getRole();
                          if (role == 'actor') {
                            Get.toNamed('/signuplocation');
                          } else {
                            Get.toNamed('/signup');
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
