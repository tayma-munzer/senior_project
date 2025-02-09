import 'package:flutter/material.dart';

class CustomEditableTextFormField extends StatelessWidget {
  final String hint;
  final void Function(String?)? onSave;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CustomEditableTextFormField({
    Key? key,
    required this.hint,
    this.onSave,
    this.validator,
    this.onChanged,
    this.controller,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 370,
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              onSaved: onSave,
              validator: validator,
              onChanged: onChanged,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: const OutlineInputBorder(
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
