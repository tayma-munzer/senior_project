import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewActorsController extends GetxController {
  var actorsList = <Map>[].obs;
  var searchQuery = ''.obs;
  var userCountry = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActors();
  }

  Future<void> fetchActors() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/actors'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        actorsList.assignAll(data.map((actor) {
          final country = actor['additional_info']['current_country']
                  ['contry'] ??
              'Unknown';

          if (actor['email'] == prefs.getString('user_email')) {
            userCountry.value = country;
          }

          return {
            'id': actor['id'],
            'first_name': actor['first_name'],
            'last_name': actor['last_name'],
            'email': actor['email'],
            'phone_number': actor['phone_number'],
            'landline_number': actor['landline_number'],
            'availability': actor['additional_info']['available'],
            'country': country,
            'date_of_birth': actor['additional_info']['date_of_birth'],
            'personal_image': actor['additional_info']['personal_image'] ??
                '/media/default.jpg', // Ensure personal_image exists in the API response
          };
        }).toList());
      } else {
        print('Failed to load actors: ${response.body}');
      }
    } catch (e) {
      print('Error fetching actors: $e');
    }
  }

  List<Map> filteredActors() {
    if (searchQuery.value.isEmpty) {
      return actorsList;
    }
    return actorsList.where((actor) {
      final fullName = '${actor['first_name']} ${actor['last_name']}';
      return fullName.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }
}
