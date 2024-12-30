import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senior_app/auth_controller.dart';
import 'package:senior_app/director_home_page/artwork.dart';

class DirectorHomeController extends GetxController {
  var artworks = <Artwork>[].obs;

  @override
  void onInit() {
    fetchArtworks();
    super.onInit();
  }

  Future<void> fetchArtworks() async {
    try {
      String? token = await AuthController().getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar('rrror', 'token is missing. please log in again.');
        return;
      }

      print('Token being sent: Bearer $token');

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/artwork'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Response Body: ${response.body}');
        List jsonResponse = json.decode(response.body);
        artworks.value =
            jsonResponse.map((artwork) => Artwork.fromJson(artwork)).toList();
      } else if (response.statusCode == 401) {
        Get.snackbar('Error', 'Unauthorized. Please log in again.');
        await AuthController().logout();
      } else {
        Get.snackbar(
            'Error', 'Failed to load artworks: ${response.statusCode}');
        print('Error Response: ${response.body}');
      }
    } catch (e) {
      print('Error fetching artworks: $e');
      Get.snackbar('Error', 'An error occurred while fetching artworks.');
    }
  }
}
