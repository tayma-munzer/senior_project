import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:senior_app/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddArtworkPosterController extends GetxController {
  TextEditingController titleController = TextEditingController();
  Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<int?> uploadArtwork() async {
    try {
      String? token = await AuthController().getToken();
      if (token == null) {
        Get.snackbar('Error', 'User not authenticated');
        return null;
      }

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.0.2.2:8000/artwork'));
      request.headers['Authorization'] = 'Token $token';
      request.fields['title'] = titleController.text;

      if (selectedImage.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'poster', selectedImage.value!.path));
      }

      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final responseData = json.decode(responseBody);
        final artworkId = responseData['id'];
        return artworkId;
      } else {
        Get.snackbar('Error', 'Failed to upload artwork');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
      return null;
    }
  }
}
