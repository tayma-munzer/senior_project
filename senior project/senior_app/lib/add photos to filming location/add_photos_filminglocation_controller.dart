import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddPhotoFilmingLocationController extends GetxController {
  RxList<File> selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;

  Future<void> pickImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: $e');
    }
  }

  Future<void> uploadImages(int locationId) async {
    if (selectedImages.isEmpty) {
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

      var uri = Uri.parse('http://10.0.2.2:8000/location/$locationId/photos');
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Token $token';

      for (var image in selectedImages) {
        try {
          if (await image.exists() && image.path.isNotEmpty) {
            print('Adding image: ${image.path}');
            int fileLength = await image.length();
            if (fileLength > 0) {
              request.files.add(
                await http.MultipartFile.fromPath(
                  'photo',
                  image.path,
                ),
              );
            } else {
              print('Skipped image (zero length): ${image.path}');
            }
          } else {
            print(
                'Skipped image (does not exist or empty path): ${image.path}');
          }
        } catch (e) {
          print('Error processing image ${image.path}: $e');
          continue;
        }
      }

      if (request.files.isEmpty) {
        Get.snackbar('Error', 'No valid image files to upload.');
        return;
      }

      var response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Photos uploaded successfully');
        Get.toNamed('/welcome');
      } else {
        Get.snackbar(
            'Error', 'Failed to upload photos: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      print('Upload error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
