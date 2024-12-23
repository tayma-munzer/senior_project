import 'package:flutter/material.dart';
import 'package:senior_app/widgets/custom_text.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final void Function(String?)? onSave;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputType keyboardType;

  const CustomTextFormField({
    Key? key,
    required this.hint,
    this.onSave,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 8),
          Container(
            width: 370,
            child: TextFormField(
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              onSaved: onSave,
              validator: validator,
              onChanged: onChanged,
              keyboardType: keyboardType,
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
          ),
        ],
      ),
    );
  }
}
