import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'login_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../colors.dart';

class LoginView extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Image.asset('assets/topbluecorner.png',
                width: 300, height: 300),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Image.asset('assets/bottompinkcorner.png',
                width: 200, height: 300),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 50),
                    Image.asset('assets/login.png', width: 300),
                    CustomText(
                      text: "تسجيل دخول",
                      fontSize: 24,
                      color: Colors.black,
                      alignment: Alignment.topRight,
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      text: "يرجى تسجيل الدخول للمتابعة",
                      color: grayColor,
                      alignment: Alignment.topRight,
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      text: "البريد الالكتروني",
                      alignment: Alignment.topRight,
                    ),
                    CustomTextFormField(
                      hint: "البريد الالكتروني",
                      onSave: (value) => controller.email = value,
                      validator: controller.validateEmail,
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      text: " كلمة المرور",
                      alignment: Alignment.topRight,
                    ),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      hint: "كلمة المرور",
                      onSave: (value) => controller.password = value,
                      validator: controller.validatePassword,
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: "تسجيل دخول",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          await controller.login();
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child: CustomText(
                        text: "هل نسيت كلمة المرور؟",
                        color: grayColor,
                        alignment: Alignment.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/signup');
                      },
                      child: CustomText(
                        text: "ليس لديك حساب؟انشء واحدا",
                        color: grayColor,
                        alignment: Alignment.center,
                      ),
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
