import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senior_app/auth_controller.dart';

class SceneDetailsController extends GetxController {
  var sceneDetails = Rx<SceneDetails?>(null);
  var isLoading = false.obs;
  var sceneActors = <SceneActor>[].obs;
  late int sceneId;
  var showFullDetails = false.obs;
  var isEditingTitle = false.obs;
  var editedTitle = ''.obs;
  var editedStartDate = ''.obs;
  var editedEndDate = ''.obs;
  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> args = Get.arguments;
    sceneId = args['scene_id'];
    fetchSceneDetails();
    fetchSceneActors();
  }

  Future<void> fetchSceneDetails() async {
    try {
      isLoading(true);
      String? token = await AuthController().getToken();
      if (token == null) {
        print("Error: User token is null");
        return;
      }
      var response = await http.get(
        Uri.parse('http://10.0.2.2:8000/scene/$sceneId'),
        headers: {'Authorization': 'Token $token'},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        sceneDetails.value = SceneDetails.fromJson(data);
      } else {
        print("Error fetching scene details: ${response.body}");
      }
    } catch (e) {
      print("Exception while fetching scene details: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSceneActors() async {
    try {
      isLoading(true);
      String? token = await AuthController().getToken();
      if (token == null) {
        print("Error: User token is null");
        return;
      }
      var response = await http.get(
        Uri.parse('http://10.0.2.2:8000/scene/$sceneId/actors'),
        headers: {'Authorization': 'Token $token'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        sceneActors.value =
            data.map((item) => SceneActor.fromJson(item)).toList();
      } else {
        print("Error fetching scene actors: ${response.body}");
      }
    } catch (e) {
      print("Exception while fetching scene actors: $e");
    } finally {
      isLoading(false);
    }
  }

  void toggleDetails() {
    showFullDetails.value = !showFullDetails.value;
  }

  void editSceneDetails() {
    Get.toNamed('/editSceneDetails', arguments: {
      'scene_id': sceneId,
      'scene_title': editedTitle.value,
      'start_date': editedStartDate.value,
      'end_date': editedEndDate.value,
    });
  }

  void toggleSceneStatus() {
    print("تغير حالة المشهد");
  }

  void editLocation() {
    print(" تعديل الموقع");
  }

  Future<void> updateSceneDetails() async {
    try {
      isLoading(true);
      String? token = await AuthController().getToken();
      if (token == null) {
        Get.snackbar('Error', 'Token is missing. Please log in again.');
        return;
      }

      var response = await http.put(
        Uri.parse('http://10.0.2.2:8000/scene/$sceneId'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': editedTitle.value,
          'start_date': editedStartDate.value,
          'end_date': editedEndDate.value,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Scene details updated successfully.');
        Get.back();
      } else {
        Get.snackbar('Error', 'Failed to update scene details.');
      }
    } catch (e) {
      print("Exception while updating scene details: $e");
      Get.snackbar('Error', 'An error occurred while updating the scene.');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteScene() async {
    try {
      isLoading(true);
      String? token = await AuthController().getToken();
      if (token == null) {
        Get.snackbar('Error', 'Token is missing. Please log in again.');
        return;
      }

      var response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/scene/$sceneId'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Scene deleted successfully.');

        Get.offNamed('/directorHome');
      } else {
        Get.snackbar('Error', 'Failed to delete scene: ${response.body}');
      }
    } catch (e) {
      print("Exception while deleting scene: $e");
      Get.snackbar('Error', 'An error occurred while deleting the scene.');
    } finally {
      isLoading(false);
    }
  }
}

class SceneDetails {
  final int id;
  final String title;
  final String startDate;
  final String endDate;
  final int sceneNumber;
  final bool done;
  final Artwork artwork;
  final Location location;

  SceneDetails({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.sceneNumber,
    required this.done,
    required this.artwork,
    required this.location,
  });

  factory SceneDetails.fromJson(Map<String, dynamic> json) {
    return SceneDetails(
      id: json['id'],
      title: json['title'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      sceneNumber: json['scene_number'],
      done: json['done'],
      artwork: Artwork.fromJson(json['artwork']),
      location: Location.fromJson(json['location']),
    );
  }
}

class Artwork {
  final int id;
  final String title;
  final String poster;

  Artwork({
    required this.id,
    required this.title,
    required this.poster,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'],
      title: json['title'],
      poster: json['poster'],
    );
  }
}

class Location {
  final int id;
  final String location;
  final String detailedAddress;
  final String desc;
  final String? photo;

  final BuildingStyle buildingStyle;
  final BuildingType buildingType;

  Location({
    required this.id,
    required this.location,
    required this.detailedAddress,
    required this.desc,
    this.photo,
    required this.buildingStyle,
    required this.buildingType,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      location: json['location'],
      detailedAddress: json['detailed_address'],
      desc: json['desc'],
      photo: json['photo'],
      buildingStyle: BuildingStyle.fromJson(json['building_style']),
      buildingType: BuildingType.fromJson(json['building_type']),
    );
  }
}

class BuildingStyle {
  final String buildingStyle;

  BuildingStyle({required this.buildingStyle});

  factory BuildingStyle.fromJson(Map<String, dynamic> json) {
    return BuildingStyle(buildingStyle: json['building_style']);
  }
}

class BuildingType {
  final String buildingType;

  BuildingType({required this.buildingType});

  factory BuildingType.fromJson(Map<String, dynamic> json) {
    return BuildingType(buildingType: json['building_type']);
  }
}

class SceneActor {
  final int id;
  final String firstName;
  final String lastName;

  SceneActor({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory SceneActor.fromJson(Map<String, dynamic> json) {
    final actorData = json['actor'] ?? {};

    return SceneActor(
      id: json['id'] ?? 0,
      firstName: actorData['first_name'] ?? "Unknown",
      lastName: actorData['last_name'] ?? "Unknown",
    );
  }
}
