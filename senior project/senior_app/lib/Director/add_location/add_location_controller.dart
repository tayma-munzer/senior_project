import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:senior_app/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddLocationController extends GetxController {
  var searchQuery = ''.obs;
  var locations = <Map<String, dynamic>>[].obs;
  var selectedLocationIndex = (-1).obs;
  var sceneName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  @override
  void onReady() {
    super.onReady();
    refreshData();
  }

  Future<void> refreshData() async {
    locations.clear();
    selectedLocationIndex.value = -1;
    await fetchLocations();
  }

  Future<void> fetchLocations() async {
    final token = await Get.find<AuthController>().getToken();
    if (token == null) {
      print("No token found");
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/filming_location'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      locations.value = data
          .map((item) => {
                'id': item['id'],
                'location': item['location'],
                'detailed_address': item['detailed_address'],
                'desc': item['desc'],
                'building_style': item['building_style']['building_style'],
                'building_type': item['building_type']['building_type'],
                'photo': item['photo'],
              })
          .toList();
    } else {
      print('Failed to load locations');
    }
  }

  void selectLocation(int index) {
    if (index >= 0 && index < locations.length) {
      selectedLocationIndex.value = index;
    } else {
      selectedLocationIndex.value = -1;
    }
  }

  void submitLocation() {
    if (selectedLocationIndex.value < 0 ||
        selectedLocationIndex.value >= locations.length) {
      print("No valid location selected!");
      return;
    }

    var selectedLocation = locations[selectedLocationIndex.value];
    var locationData = {
      'scene_name': sceneName.value,
      'location_id': selectedLocation['id'],
    };

    print("Location submitted: $locationData");
  }
}
