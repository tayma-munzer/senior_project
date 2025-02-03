import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class SignUpLocationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController birthDateController = TextEditingController();
  RxString selectedCountry = "سوريا".obs;
  RxList<String> countries = <String>[].obs;
  String birthDate = "";

  @override
  void onInit() {
    super.onInit();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/countries'));
      if (response.statusCode == 200) {
        final List<dynamic> countryList = json.decode(response.body);
        countries.value =
            countryList.map((e) => e['contry'] as String).toList();
        if (countries.isNotEmpty) {
          selectedCountry.value = countries.first;
        }
      } else {
        Get.snackbar('Error', 'Failed to load countries');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching countries');
      print(e);
    }
  }

  void saveLocation() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      print("Selected Country: ${selectedCountry.value}");
      print("Birth Date: $birthDate");
    }
  }

  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      birthDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      birthDateController.text = birthDate;
      update();
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
