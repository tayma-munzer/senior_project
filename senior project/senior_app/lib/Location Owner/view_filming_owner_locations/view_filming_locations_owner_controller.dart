import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewOwnerFilmingLocationController extends GetxController {
  RxList locations = [].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchLocations() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/my_filming_locations'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      try {
        // Decode the response body using UTF-8 to handle Arabic characters
        String utf8ResponseBody = utf8.decode(response.bodyBytes);
        // Parse the decoded JSON string
        final decodedData = json.decode(utf8ResponseBody);

        if (decodedData is List) {
          locations.value = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          locations.value = decodedData['data'];
        } else {
          locations.value = [];
        }
      } catch (e) {
        print('Error decoding JSON: $e');
        Get.snackbar('Error', 'Failed to decode response');
      }
    } else {
      Get.snackbar('Error', 'Failed to load locations');
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }
}
