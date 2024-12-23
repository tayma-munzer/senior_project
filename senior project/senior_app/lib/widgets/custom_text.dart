import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final double fontSize;
  final Color labelColor;
  final Color hintColor;
  final Alignment alignment;

  CustomTextField({
    this.labelText = '',
    this.hintText = '',
    this.fontSize = 16,
    this.labelColor = Colors.black,
    this.hintColor = Colors.grey,
    this.alignment = Alignment.topLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: labelText,
            fontSize: fontSize,
            color: labelColor,
          ),
          SizedBox(height: 4),
          TextField(
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: hintColor),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final Alignment alignment;

  CustomText({
    this.text = '',
    this.fontSize = 16,
    this.color = Colors.black,
    this.alignment = Alignment.topLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: fontSize),
      ),
    );
  }
}
