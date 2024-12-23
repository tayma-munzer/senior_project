import 'package:get/get.dart';

class AddSceneActorsController extends GetxController {
  var sceneName = ''.obs;

  var actors = [
    {
      "name": "Actor 1",
      "age": "45",
      "type": "Lead Role",
      "image": "assets/login.png"
    },
    {
      "name": "Actor 2",
      "age": "50",
      "type": "Supporting",
      "image": "assets/login.png"
    },
    {
      "name": "Actor 3",
      "age": "38",
      "type": "Guest Role",
      "image": "assets/login.png"
    },
  ].obs;

  var selectedActors = List.generate(3, (index) => false).obs;
  var selectedActorList = <Map<String, dynamic>>[].obs;

  void toggleSelection(int index, bool value) {
    selectedActors[index] = value;

    if (value) {
      selectedActorList.add(actors[index]);
    } else {
      selectedActorList
          .removeWhere((actor) => actor['name'] == actors[index]['name']);
    }
  }

  void submitScene() {
    print("Scene Name: ${sceneName.value}"); // Print the scene name
    print("Selected Actors:");

    if (selectedActorList.isEmpty) {
      print("No actors selected.");
    } else {
      for (var actor in selectedActorList) {
        print(actor['name']); // Print only the name of the selected actor.
      }
    }
  }

  void addActor() {
    print("Add actor tapped");
  }
}
