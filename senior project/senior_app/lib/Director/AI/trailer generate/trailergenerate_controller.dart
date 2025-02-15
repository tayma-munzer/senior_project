import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senior_app/auth_controller.dart';

class TrailergeneraterController extends GetxController {
  var youtubeLink = ''.obs;
  var videoDuration = ''.obs;
  var numberOfScenes = ''.obs;
  var text = ''.obs;
  var showVideo = false.obs;
  var isLoading = false.obs;
  var videoUrl = ''.obs;

  Future<void> generateTrailer() async {
    if (youtubeLink.isEmpty ||
        videoDuration.isEmpty ||
        numberOfScenes.isEmpty ||
        text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى ملء جميع الحقول');
      return;
    }

    try {
      isLoading(true);
      String? token = await AuthController().getToken();
      if (token == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على رمز المستخدم');
        return;
      }

      final Map<String, dynamic> requestBody = {
        'youtube_link': youtubeLink.value,
        'video_duration': videoDuration.value,
        'number_of_scenes': numberOfScenes.value,
        'text': text.value,
      };

      var response = await http.post(
        Uri.parse('http://10.0.2.2:8000/trailer'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        videoUrl.value = responseData['video_url'];
        showVideo.value = true;
        Get.snackbar('نجاح', 'تم توليد الإعلان بنجاح');
      } else {
        Get.snackbar('خطأ', 'فشل في توليد الإعلان: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء الاتصال بالخادم: $e');
    } finally {
      isLoading(false);
    }
  }
}
