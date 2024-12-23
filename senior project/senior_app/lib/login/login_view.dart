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
      backgroundColor: backgroundColor,
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
                        text: "LOGIN", fontSize: 24, color: Colors.black),
                    SizedBox(height: 10),
                    CustomText(
                        text: "Please sign in to continue", color: grayColor),
                    SizedBox(height: 10),
                    CustomText(text: "Phone number or Email"),
                    CustomTextFormField(
                      hint: "Phone number or Email",
                      onSave: (value) => controller.email = value,
                      validator: controller.validateEmailOrPhone,
                    ),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      hint: "Password",
                      onSave: (value) => controller.password = value,
                      validator: controller.validatePassword,
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: "Sign In",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          String? token = await controller.login();

                          if (token != null) {
                            // Print the token
                            print("User token: $token");
                            // Navigate to the home screen
                            Get.offNamed('/directorHome');
                          } else {
                            Get.snackbar("Error", "Invalid credentials");
                          }
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child: CustomText(
                          text: "Forgot password?", color: grayColor),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/signup');
                      },
                      child: CustomText(
                          text: "Don't have an account? Sign Up",
                          color: grayColor),
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
