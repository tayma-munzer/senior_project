import 'package:flutter/material.dart';
import 'package:senior_app/widgets/custom_text.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final void Function(String?)? onSave;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    Key? key,
    required this.hint,
    this.onSave,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.end, // Aligns everything to the right
        children: [
          CustomText(
            fontSize: 16,
            color: Colors.grey.shade900,
          ),
          SizedBox(height: 8),
          TextFormField(
            textAlign: TextAlign.right, // Aligns user input text to the right
            textDirection: TextDirection.rtl, // Aligns hint text to the right
            onSaved: onSave,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
