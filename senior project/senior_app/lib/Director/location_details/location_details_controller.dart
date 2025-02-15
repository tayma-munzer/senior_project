import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewLocationDetailsController extends GetxController {
  final location = <String, dynamic>{}.obs;
  final photos = <Map<String, dynamic>>[].obs;
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      location.value = args;
      fetchPhotos();
    }
    pageController = PageController();
  }

  Future<void> fetchPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final locationId = location['id'];

    if (locationId == null || token == null) {
      print('Invalid location ID or user token');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/location/$locationId/photos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        photos.assignAll(data.cast<Map<String, dynamic>>());
        print('Fetched photos: $photos');
      } else {
        print('Failed to load photos: ${response.body}');
      }
    } catch (e) {
      print('Error fetching photos: $e');
    }
  }

  void nextPage() {
    pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
