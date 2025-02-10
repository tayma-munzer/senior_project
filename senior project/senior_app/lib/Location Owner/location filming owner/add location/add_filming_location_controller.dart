import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddFilmingLocationController extends GetxController {
  var location = ''.obs;
  var detailedAddress = ''.obs;
  var description = ''.obs;
  var buildingStyles = <Map<String, dynamic>>[].obs;
  var buildingTypes = <Map<String, dynamic>>[].obs;
  var selectedBuildingStyle = RxnInt();
  var selectedBuildingType = RxnInt();

  var locationError = ''.obs;
  var addressError = ''.obs;
  var descriptionError = ''.obs;
  var buildingStyleError = ''.obs;
  var buildingTypeError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBuildingStyles();
    fetchBuildingTypes();
  }

  Future<void> fetchBuildingStyles() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/building_styles'));
      if (response.statusCode == 200) {
        List data = json.decode(utf8.decode(response.bodyBytes));
        buildingStyles.value = data
            .map((item) => {
                  'id': item['id'],
                  'building_style': item['building_style'] ?? 'غير معروف'
                })
            .toList();
      }
    } catch (e) {
      print('Error fetching building styles: $e');
    }
  }

  Future<void> fetchBuildingTypes() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/building_types'));
      if (response.statusCode == 200) {
        List data = json.decode(utf8.decode(response.bodyBytes));
        buildingTypes.value = data
            .map((item) => {
                  'id': item['id'],
                  'building_type': item['building_type'] ?? 'غير معروف'
                })
            .toList();
      }
    } catch (e) {
      print('Error fetching building types: $e');
    }
  }

  bool validateFields() {
    bool isValid = true;

    if (location.value.isEmpty) {
      locationError.value = 'يجب ملء اسم الموقع';
      isValid = false;
    } else {
      locationError.value = '';
    }

    if (detailedAddress.value.isEmpty) {
      addressError.value = 'يجب ملء تفاصيل العنوان';
      isValid = false;
    } else {
      addressError.value = '';
    }

    if (description.value.isEmpty) {
      descriptionError.value = 'يجب ملء الوصف';
      isValid = false;
    } else {
      descriptionError.value = '';
    }

    if (selectedBuildingStyle.value == null) {
      buildingStyleError.value = 'يجب اختيار نمط البناء';
      isValid = false;
    } else {
      buildingStyleError.value = '';
    }

    if (selectedBuildingType.value == null) {
      buildingTypeError.value = 'يجب اختيار نوع البناء';
      isValid = false;
    } else {
      buildingTypeError.value = '';
    }

    return isValid;
  }

  Future<void> submitLocation() async {
    if (!validateFields()) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) return;

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/filming_location'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: json.encode({
        'location': location.value,
        'detailed_address': detailedAddress.value,
        'desc': description.value,
        'building_style_id': selectedBuildingStyle.value ?? 0,
        'building_type_id': selectedBuildingType.value ?? 0,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final int locationId = responseData['id'];
      print('Location added successfully, navigating...');
      Get.toNamed('/addphotostofilminglocation', arguments: locationId);
    } else {
      print('Failed to add location: ${response.body}');
    }
  }
}
