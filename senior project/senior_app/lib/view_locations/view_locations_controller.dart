import 'package:get/get.dart';

class ViewLocationsController extends GetxController {
  var locationsList = [
    {
      'name': 'Location 1',
      'images': ['assets/login.png'],
      'building_style': 'Modern',
      'description': 'A beautiful modern building.',
      'owner': 'Owner 1',
    },
    {
      'name': 'Location 2',
      'images': ['assets/directorhome.webp'],
      'building_style': 'Traditional',
      'description': 'A charming traditional structure.',
      'owner': 'Owner 2',
    },
    {
      'name': 'Location 3',
      'images': ['assets/topbluecorner.png'],
      'building_style': 'Contemporary',
      'description': 'A sleek contemporary building.',
      'owner': 'Owner 3',
    },
  ].obs;
  var selectedLocations = <Map>[].obs;

  var searchQuery = ''.obs;

  List filteredLocations() {
    if (searchQuery.value.isEmpty) {
      return locationsList;
    }
    return locationsList.where((location) {
      return location['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void toggleLocationSelection(Map location) {
    if (selectedLocations.contains(location)) {
      selectedLocations.remove(location);
    } else {
      selectedLocations.add(location);
    }
  }

  bool isLocationSelected(Map location) {
    return selectedLocations.contains(location);
  }
}
