import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CameraController extends GetxController {
  var showVideo = false.obs;
  var selectedVideo = Rx<File?>(null);
  var generatedVideoUrl = ''.obs;

  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedVideo.value = File(pickedFile.path);
    } else {
      Get.snackbar('خطأ', 'لم يتم اختيار أي فيديو');
    }
  }

  Future<void> uploadAndGenerateVideo() async {
    if (selectedVideo.value == null) {
      Get.snackbar('خطأ', 'يرجى اختيار فيديو أولاً');
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        Get.snackbar('خطأ', 'المستخدم غير مسجل الدخول');
        return;
      }

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.0.2.2:8000/camera_location'));
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath(
          'video', selectedVideo.value!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        generatedVideoUrl.value = jsonResponse['video_url'];
        showVideo.value = true;
      } else {
        Get.snackbar('خطأ', 'فشل رفع الفيديو');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء رفع الفيديو: $e');
    }
  }
}
