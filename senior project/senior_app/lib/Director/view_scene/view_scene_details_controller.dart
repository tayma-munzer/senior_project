import 'package:get/get.dart';

class ViewSceneDetailsController extends GetxController {
  var sceneName = ''.obs;
  var selectedActors = <Map<String, dynamic>>[].obs;
  var selectedLocation = {}.obs;
  var selectedDays = <DateTime>[].obs;

  void setSceneDetails(String name, List<Map<String, dynamic>> actors,
      Map<String, dynamic> location, List<DateTime> days) {
    sceneName.value = name;
    selectedActors.value = actors;
    selectedLocation.value = location;
    selectedDays.value = days;
  }
}
