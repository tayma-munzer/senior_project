import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class AddVideoToFilmingLocationController extends GetxController {
  Rx<File?> selectedVideo = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;

  Future<void> pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedVideo.value = File(pickedFile.path);
    }
  }

  Future<void> uploadVideo(int locationId) async {
    if (selectedVideo.value == null) {
      Get.snackbar('Error', 'يرجى اختيار فيديو أولاً');
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

      var uri = Uri.parse('http://10.0.2.2:8000/location/$locationId/videos');

      final videoBytes = await selectedVideo.value!.readAsBytes();
      final filename = basename(selectedVideo.value!.path);
      final mimeType = lookupMimeType(selectedVideo.value!.path) ?? 'video/mp4';
      final mimeParts = mimeType.split('/');

      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Token $token'
        ..files.add(
          http.MultipartFile.fromBytes(
            'video',
            videoBytes,
            filename: filename,
            contentType: MediaType(mimeParts[0], mimeParts[1]),
          ),
        );

      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'تم رفع الفيديو بنجاح');
        Get.offAllNamed('/locationownerHome'); // Navigate to Home after success
      } else {
        Get.snackbar('Error', 'فشل رفع الفيديو: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'حدث خطأ أثناء رفع الفيديو: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
