import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sign_up_controller.dart';
import 'package:senior_app/widgets/custom_button.dart';

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignUpController>(); // Get the controller

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset('assets/topbluecorner.png'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset('assets/bottompinkcorner.png'),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/signup.png'), // Path to your image
                      SizedBox(height: 20),
                      _buildTextField(
                        label: 'البريد الإلكتروني',
                        hint: 'أدخل بريدك الإلكتروني',
                        controller: controller.emailController,
                        validator: controller.validateEmail,
                      ),
                      SizedBox(height: 20),
                      GetBuilder<SignUpController>(
                        builder: (_) {
                          return _buildTextField(
                            label: 'كلمة المرور',
                            hint: 'أدخل كلمة المرور',
                            controller: controller.passwordController,
                            obscureText: !controller.isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(controller.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                            validator: controller.validatePassword,
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      GetBuilder<SignUpController>(
                        builder: (_) {
                          return _buildTextField(
                            label: 'تاكيد كلمة المرور',
                            hint: 'أعد إدخال كلمة المرور',
                            controller: controller.confirmPasswordController,
                            obscureText: !controller.isConfirmPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(controller.isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed:
                                  controller.toggleConfirmPasswordVisibility,
                            ),
                            validator: controller.validateConfirmPassword,
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        text: 'التالي',
                        onPressed: () {
                          controller
                              .saveSignUp(); // Call the saveSignUp function
                          Get.toNamed(
                              '/directorHome'); // Navigate to the signup page
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero, // No corners (rectangle)
          borderSide: BorderSide(color: Colors.grey), // Border color
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
