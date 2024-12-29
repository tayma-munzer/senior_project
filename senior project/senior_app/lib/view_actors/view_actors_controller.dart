import 'package:get/get.dart';

class ViewActorsController extends GetxController {
  var actorsList = [
    {
      'name': ' حلا مرعي',
      'images': ['assets/login.png'],
      'age': '20',
      'acting_type': 'حزين ',
    },
    {
      'name': ' حلا فادي',
      'images': ['assets/login.png'],
      'age': '20',
      'acting_type': 'دراما ',
    },
    {
      'name': ' حلا محمد',
      'images': ['assets/login.png'],
      'age': '20',
      'acting_type': 'مغامرات ',
    },
  ].obs;

  var selectedActors = <Map>[].obs;
  var searchQuery = ''.obs;

  List filteredActors() {
    if (searchQuery.value.isEmpty) {
      return actorsList;
    }
    return actorsList.where((actor) {
      return actor['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void toggleActorSelection(Map actor) {
    if (selectedActors.contains(actor)) {
      selectedActors.remove(actor);
    } else {
      selectedActors.add(actor);
    }
  }

  bool isActorSelected(Map actor) {
    return selectedActors.contains(actor);
  }
}
