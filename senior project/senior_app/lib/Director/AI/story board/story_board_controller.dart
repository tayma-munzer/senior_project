import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StoryBoardController extends GetxController {
  var text = ''.obs;
  var showVideo = false.obs;
  var isLoading = false.obs;
  var generatedVideoUrl = ''.obs;

  Future<void> generatestoryboard() async {
    if (text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال النص');
      return;
    }

    isLoading(true);

    try {
      String? token = await getToken();
      if (token == null) {
        Get.snackbar('خطأ', 'يرجى تسجيل الدخول أولاً');
        isLoading(false);
        return;
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/story_board'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode({'prompt': text.value}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        generatedVideoUrl.value = data['video_url'];
        showVideo.value = true;
        Get.snackbar('نجاح', 'تم توليد الفيديو بنجاح');
      } else {
        Get.snackbar('خطأ', 'فشل في إنشاء الفيديو');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء إنشاء الفيديو');
    } finally {
      isLoading(false);
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
