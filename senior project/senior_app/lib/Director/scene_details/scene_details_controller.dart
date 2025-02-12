import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senior_app/auth_controller.dart';

class SceneDetailsController extends GetxController {
  late int sceneId;
  var sceneDetails = {}.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    sceneId = Get.arguments['sceneId'];
    fetchSceneDetails();
  }

  Future<void> fetchSceneDetails() async {
    isLoading.value = true;
    try {
      String? token = await AuthController().getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Token is missing. Please log in again.');
        return;
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/scene/$sceneId'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        sceneDetails.value = json.decode(response.body);
      } else {
        Get.snackbar('Error', 'Failed to load scene details');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching scene details');
    } finally {
      isLoading.value = false;
    }
  }
}
