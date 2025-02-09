import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtworkGallaryDetailsController extends GetxController {
  RxMap artworkDetails = {}.obs;
  RxList<String> photos = <String>[].obs;
  RxBool isLoading = false.obs;
  RxInt currentIndex = 0.obs;
  Future<void> fetchArtworkDetails(int artworkId) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/artwork_gallary/artwork/$artworkId'),
      headers: {'Authorization': 'Token $token'},
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final decodedData = json.decode(response.body);
        artworkDetails.value = decodedData;
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      Get.snackbar('Error', 'Failed to load artwork details');
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    final artworkId = Get.arguments['artworkId'] ?? 0;
    if (artworkId != 0) {
      fetchArtworkDetails(artworkId);
    } else {
      print('Invalid artworkId passed');
    }
  }
}
