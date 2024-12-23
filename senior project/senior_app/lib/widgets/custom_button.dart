import 'package:flutter/material.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
          backgroundColor: primaryColor,
        ),
        child: CustomText(
          text: text,
          color: Colors.white,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
