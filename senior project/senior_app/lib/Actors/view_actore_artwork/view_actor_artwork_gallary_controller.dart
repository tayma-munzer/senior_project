import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewActorArtworkGallaryController extends GetxController {
  RxList artworks = [].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchArtworks() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/artwork_gallary'),
      headers: {'Authorization': 'Token $token'},
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final decodedData = json.decode(response.body);
        print('Decoded Data: $decodedData');

        if (decodedData is List) {
          artworks.value = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          artworks.value = decodedData['data'];
        } else {
          artworks.value = [];
        }
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      Get.snackbar('Error', 'Failed to load artworks');
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchArtworks();
  }
}
