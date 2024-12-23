import 'package:get/get.dart';

class ViewSceneDetailsController extends GetxController {
  // Variables to hold passed data
  var sceneName = ''.obs;
  var selectedActors = <Map<String, dynamic>>[].obs;
  var selectedLocation = {}.obs;
  var selectedDays = <DateTime>[].obs;

  // Method to set the scene details when navigating to this page
  void setSceneDetails(String name, List<Map<String, dynamic>> actors,
      Map<String, dynamic> location, List<DateTime> days) {
    sceneName.value = name;
    selectedActors.value = actors;
    selectedLocation.value = location;
    selectedDays.value = days;
  }
}
