import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPhotoFilmingLocationController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> uploadImage(int locationId) async {
    if (selectedImage.value == null) {
      Get.snackbar('Error', 'يرجى ادخال صورة واحدة على الاقل');
      return;
    }

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        Get.snackbar('Error', 'Authentication token missing');
        return;
      }

      var uri = Uri.parse('http://10.0.2.2:8000/location/$locationId/photo');

      final imageBytes = await selectedImage.value!.readAsBytes();
      final filename = basename(selectedImage.value!.path);
      final mimeType =
          lookupMimeType(selectedImage.value!.path) ?? 'image/jpeg';
      final mimeParts = mimeType.split('/');

      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Token $token'
        ..files.add(
          http.MultipartFile.fromBytes(
            'photo',
            imageBytes,
            filename: filename,
            contentType: MediaType(mimeParts[0], mimeParts[1]),
          ),
        );

      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Photo uploaded successfully');
        Get.toNamed('/addvideostofilminglocation');
      } else {
        Get.snackbar('Error', 'Failed to upload photo: ${response.statusCode}');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
