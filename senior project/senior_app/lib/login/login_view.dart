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
                        text: "please sign in to continue", color: grayColor),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      text: "Phone number or Email",
                      hint: "Phone number or Email",
                      onSave: (value) => controller.emailOrPhone = value,
                      validator: controller.validateEmailOrPhone,
                    ),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      text: "Password",
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

                          try {
                            //  backend authentication succeeds, navigate to Director Home Page
                            bool isAuthenticated = await authenticateUser(
                                controller.emailOrPhone, controller.password);

                            if (isAuthenticated) {
                              Get.offNamed('/directorHome');
                            } else {
                              Get.snackbar("Error",
                                  "Invalid credentials, please try again");
                            }
                          } catch (e) {
                            Get.snackbar(
                                "Error", "An error occurred: ${e.toString()}");
                          }
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child: CustomText(
                        text: "Forgot password?",
                        color: grayColor,
                        alignment: Alignment.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/signup');
                      },
                      child: CustomText(
                        text: "Don't have an account? Sign Up",
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

  Future<bool> authenticateUser(String? emailOrPhone, String? password) async {
    print(
        "Authenticating user with Email/Phone: $emailOrPhone and Password: $password");

    if (emailOrPhone == "test@example.com" && password == "password") {
      return true;
    }
    return false;
  }
}
