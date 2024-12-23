import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpLocationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  String selectedCountry = "سوريا";
  String birthDate = "";

  void saveLocation() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      print("Selected Country: $selectedCountry");
      print("Birth Date: $birthDate");
      // Call API or navigate to the next screen here
    }
  }

  String? validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال تاريخ الميلاد';
    }

    try {
      final dateParts = value.split('/');
      if (dateParts.length != 3) throw FormatException();
      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);

      final birthDate = DateTime(year, month, day);
      final now = DateTime.now();
      if (now.year - birthDate.year < 18 ||
          (now.year - birthDate.year == 18 &&
              (now.month < birthDate.month ||
                  (now.month == birthDate.month && now.day < birthDate.day)))) {
        return 'يجب أن تكون أكبر من 18 عامًا';
      }
    } catch (e) {
      return 'التاريخ يجب أن يكون بصيغة يوم/شهر/سنة';
    }

    return null;
  }
}
