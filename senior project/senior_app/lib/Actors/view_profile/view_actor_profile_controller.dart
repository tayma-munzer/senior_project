import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewActorProfileController extends GetxController {
  RxMap userProfile = {}.obs;
  RxBool isLoading = true.obs;
  RxString availability = 'غير متوفر'.obs;
  RxList<Map<String, dynamic>> countries = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        userProfile.value = json.decode(response.body);
        availability.value = userProfile['additional_info']['approved'] == true
            ? 'متوفر'
            : 'غير متوفر';
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
    isLoading.value = false;
  }

  Future<void> updateAvailability(bool available) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) return;

    try {
      final response = await http.patch(
        Uri.parse('http://10.0.2.2:8000/additional_info'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode({
          "available": available,
        }),
      );

      if (response.statusCode == 200) {
        userProfile['additional_info']['available'] = available;
        userProfile['additional_info']['approved'] = available;
        availability.value = available ? 'متوفر' : 'غير متوفر';
        userProfile.refresh();
      }
    } catch (e) {
      print('Error updating availability: $e');
    }
  }

  Future<void> fetchCountries() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/countries'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          countries.value = data.map<Map<String, dynamic>>((country) {
            return {
              'id': country.containsKey('id') ? country['id'] : 0,
              'name': country.containsKey('name') && country['name'] != null
                  ? country['name']
                  : 'غير معروف',
            };
          }).toList();
          print('Fetched countries successfully: $countries');
        } else {
          print('Error: Received empty country list');
        }
      } else {
        print('Failed to fetch countries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching countries: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء جلب الدول');
    }
  }

  Future<void> updateCurrentCountry(int countryId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) return;

    try {
      final response = await http.patch(
        Uri.parse('http://10.0.2.2:8000/additional_info'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode({
          "current_country": countryId,
        }),
      );

      if (response.statusCode == 200) {
        userProfile['additional_info']['current_country'] =
            json.decode(response.body)['current_country'];
        userProfile.refresh();
        Get.snackbar('نجاح', 'تم تحديث الدولة الحالية بنجاح');
      }
    } catch (e) {
      print('Error updating current country: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء تحديث الدولة الحالية');
    }
  }
}
