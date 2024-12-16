import 'package:get/get.dart';

class ArtworkDetailsController extends GetxController {
  String artworkTitle = "Sample Artwork Title";
  String artworkDescription = "Detailed description of the artwork goes here.";
  String artworkOwner = "Owner: John Doe";
  String artworkDate = "Date: October 8, 2024";

  var actors = <Actor>[
    Actor(name: "Actor One", role: "Lead Role"),
    Actor(name: "Actor Two", role: "Supporting Role"),
    Actor(name: "Actor three", role: "Supporting Role")
  ].obs;

  var scenes = <Scene>[
    Scene(title: "Scene 1", description: "Opening scene", isFinished: true),
    Scene(title: "Scene 2", description: "Closing scene", isFinished: false)
  ].obs;

  void deleteActor(Actor actor) {
    actors.remove(actor);
  }

  void deleteScene(Scene scene) {
    scenes.remove(scene);
  }
}

class Actor {
  String name;
  String role;

  Actor({required this.name, required this.role});
}

class Scene {
  String title;
  String description;
  bool isFinished;

  Scene(
      {required this.title,
      required this.description,
      required this.isFinished});
}
