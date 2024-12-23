import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/signup/sign_up_choices/sign_up_choices_controller.dart';
import 'package:senior_app/widgets/custom_text.dart';

class SignUpChoicesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignUpChoicesController>();
    final screenWidth = MediaQuery.of(context).size.width;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/choices.png',
                  width: 300,
                  height: 300,
                ),
                SizedBox(height: 20),
                _buildChoiceButton(controller, 'ممثل', screenWidth),
                SizedBox(height: 10),
                _buildChoiceButton(controller, 'مخرج', screenWidth),
                SizedBox(height: 10),
                _buildChoiceButton(controller, 'صاحب موقع', screenWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildChoiceButton(
      SignUpChoicesController controller, String choice, double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.9,
      height: screenWidth * 0.13,
      child: ElevatedButton(
        onPressed: () {
          controller.setChoice(choice);
          print('Selected choice: $choice');
          Get.toNamed('/signuppersonalinformation');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: CustomText(
          text: choice,
          color: whiteColor,
          alignment: Alignment.center,
          fontSize: 20,
        ),
      ),
    );
  }
}
