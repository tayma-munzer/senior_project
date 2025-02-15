import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LipSyncController extends GetxController {
  var text = ''.obs;
  var selectedVideo = Rx<File?>(null);
  var generatedVideoUrl = ''.obs;
  var isLoading = false.obs;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedVideo.value = File(pickedFile.path);
    } else {
      Get.snackbar('خطأ', 'لم يتم اختيار أي فيديو');
    }
  }

  Future<void> generateLipSync() async {
    if (text.isEmpty || selectedVideo.value == null) {
      Get.snackbar('خطأ', 'يرجى إدخال النص واختيار الفيديو');
      return;
    }

    String? token = await getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar('خطأ', 'المستخدم غير مسجل الدخول');
      return;
    }

    isLoading(true);
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/sync_lips'),
      );
      request.headers['Authorization'] = 'Token $token';

      request.fields['text'] = text.value;

      request.files.add(await http.MultipartFile.fromPath(
        'video',
        selectedVideo.value!.path,
      ));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        generatedVideoUrl.value = jsonResponse['video_url'];
        Get.snackbar('نجاح', 'تم توليد الفيديو بنجاح');
      } else {
        Get.snackbar('خطأ', 'فشل في توليد الفيديو');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء معالجة الطلب');
    } finally {
      isLoading(false);
    }
  }
}
