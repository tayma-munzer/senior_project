import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewLocationOwnerLocationDetailsController extends GetxController {
  RxMap locationDetails = {}.obs;
  RxList<String> photos = <String>[].obs;
  RxBool isLoading = false.obs;
  RxInt currentIndex = 0.obs;
  Future<void> fetchLocationDetails(int locationId) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/filming_location/$locationId'),
      headers: {'Authorization': 'Token $token'},
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final decodedData = json.decode(response.body);
        locationDetails.value = decodedData;

        await fetchLocationPhotos(locationId, token);
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      Get.snackbar('Error', 'Failed to load location details');
    }
    isLoading.value = false;
  }

  Future<void> fetchLocationPhotos(int locationId, String token) async {
    final responsePhotos = await http.get(
      Uri.parse('http://10.0.2.2:8000/location/$locationId/photos'),
      headers: {'Authorization': 'Token $token'},
    );

    if (responsePhotos.statusCode == 200) {
      try {
        final List<dynamic> decodedPhotos = json.decode(responsePhotos.body);

        photos.value = decodedPhotos.map<String>((photoData) {
          return photoData['photo'] as String;
        }).toList();

        print('Photos: ${photos.value}');
      } catch (e) {
        print('Error decoding photos JSON: $e');
      }
    } else {
      Get.snackbar('Error', 'Failed to load location photos');
    }
  }

  void changeImage(int direction) {
    if (photos.isNotEmpty) {
      currentIndex.value = (currentIndex.value + direction) % photos.length;
      if (currentIndex.value < 0) {
        currentIndex.value = photos.length - 1;
      }
    }
  }

  Future<void> deleteLocation(int locationId) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/filming_location/$locationId'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Location deleted successfully');
      Get.offAllNamed('/locationHome');
    } else {
      Get.snackbar('Error', 'Failed to delete location');
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    final locationId = Get.arguments['locationId'] ?? 0;
    if (locationId != 0) {
      fetchLocationDetails(locationId);
    } else {
      print('Invalid locationId passed');
    }
  }
}
