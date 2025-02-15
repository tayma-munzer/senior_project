import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senior_app/auth_controller.dart';
import 'package:senior_app/Director/director_home_page/artwork.dart';

class DirectorHomeController extends GetxController {
  var artworks = <Artwork>[].obs;
  var selectedArtworkId = 0.obs;

  @override
  void onInit() {
    fetchArtworks();
    super.onInit();
  }

  @override
  void onReady() {
    fetchArtworks();
    super.onReady();
  }

  Future<void> fetchArtworks() async {
    try {
      String? token = await AuthController().getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Token is missing. Please log in again.');
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
        String utf8ResponseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(utf8ResponseBody);

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

  void setSelectedArtwork(int id) {
    selectedArtworkId.value = id;
  }
}
