import 'package:get/get.dart';

class AddLocationController extends GetxController {
  var searchQuery = ''.obs;

  var locations = [
    {
      "name": "Location 1",
      "address": "123 Main St",
      "type": "Urban",
      "image": "assets/login.png"
    },
    {
      "name": "Location 2",
      "address": "456 Elm St",
      "type": "Rural",
      "image": "assets/login.png"
    },
    {
      "name": "Location 3",
      "address": "789 Oak St",
      "type": "Suburban",
      "image": "assets/login.png"
    },
  ].obs;

  var selectedLocationIndex = (-1).obs;

  void selectLocation(int index) {
    selectedLocationIndex.value = index;
  }

  void submitLocation() {
    if (selectedLocationIndex.value == null ||
        selectedLocationIndex.value < 0) {
      print("No location selected!");
      return; // Exit early if no location is selected
    }

    print("Location submitted: ${locations[selectedLocationIndex.value]}");
  }
}
