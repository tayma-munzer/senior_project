import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:senior_app/auth_controller.dart';

class ChromaController extends GetxController {
  var explanation = ''.obs;
  var selectedImage = Rx<File?>(null);
  var generatedImageUrl = ''.obs;

  final String apiUrl = 'http://10.0.2.2:8000/chroma';

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> generateImage() async {
    try {
      String? token = await AuthController().getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      if (selectedImage.value == null || explanation.value.isEmpty) {
        Get.snackbar('Error', 'Please add an image and enter a description');
        return;
      }

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers['Authorization'] = 'Token $token';
      request.files.add(
          await http.MultipartFile.fromPath('file', selectedImage.value!.path));
      request.fields['prompt'] = explanation.value;

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200 && jsonResponse.containsKey('image_url')) {
        generatedImageUrl.value = jsonResponse['image_url'];
      } else {
        Get.snackbar('Error', 'Failed to generate image');
      }
    } catch (e) {
      print('Error generating image: $e');
      Get.snackbar('Error', 'An error occurred while generating the image');
    }
  }
}
