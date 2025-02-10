import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:senior_app/auth_controller.dart';

class AddArtworkPosterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final imagePath = ''.obs;
  Future<void> pickImage() async {
    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          imagePath.value = pickedFile.path;
          Get.snackbar('Success', 'Image selected successfully.');
        } else {
          Get.snackbar('No Image', 'No image was selected.');
        }
      } else {
        Get.snackbar('Permission Denied', 'Gallery access denied.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while picking the image: $e');
    }
  }

  Future<void> submitArtwork() async {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter the name of the artwork.');
      return;
    }

    String? token = await AuthController().getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token is missing. Please log in again.');
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/artwork'),
      );
      request.headers['Authorization'] = 'Token $token';
      request.fields['title'] = nameController.text;

      if (imagePath.value.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'poster',
            imagePath.value,
            filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Artwork added successfully!');
        Get.back();
      } else {
        final responseBody = await response.stream.bytesToString();
        Get.snackbar('Error', 'Failed to add artwork: $responseBody');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
