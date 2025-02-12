import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senior_app/auth_controller.dart';

class AddSceneActorsController extends GetxController {
  var actors = <Map<String, dynamic>>[].obs;
  var selectedActors = <bool>[].obs;
  var selectedActorList = <Map<String, dynamic>>[].obs;

  late int artworkId;
  late int sceneId;

  @override
  void onInit() {
    super.onInit();
    artworkId = Get.arguments['artworkId'];
    sceneId = Get.arguments['sceneId'];
    fetchActors();
  }

  Future<void> fetchActors() async {
    try {
      String? token = await AuthController().getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Token is missing. Please log in again.');
        return;
      }

      actors.clear();
      selectedActors.clear();
      selectedActorList.clear();

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/artwork/$artworkId/actors'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        if (jsonResponse.isEmpty) {
          Get.snackbar('Info', 'لا يوجد ممثلين للاختيار منهم');
          return;
        }

        actors.value = jsonResponse.map<Map<String, dynamic>>((item) {
          int actorId = item['actor']['id'];
          String firstName = item['actor']['first_name'] ?? '';
          String lastName = item['actor']['last_name'] ?? '';
          String name = "$firstName $lastName";
          String type = item['role_type']?['role_type'] ?? '';
          String dob = item['actor']['additional_info']?['date_of_birth'] ?? '';
          String image = item['actor']['additional_info']?['personal_image'] ??
              'assets/login.png';

          if (image.startsWith('/')) {
            image = "http://10.0.2.2:8000$image";
          }

          return {
            "actor_id": actorId,
            "name": name,
            "age": dob,
            "type": type,
            "image": image,
          };
        }).toList();

        selectedActors.value =
            List<bool>.generate(actors.length, (index) => false);
      } else {
        Get.snackbar('Error', 'Failed to load actors: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching actors: $e");
      Get.snackbar('Error', 'An error occurred while fetching actors.');
    }
  }

  void toggleSelection(int index, bool value) {
    selectedActors[index] = value;

    if (value) {
      selectedActorList.add(actors[index]);
    } else {
      selectedActorList.removeWhere(
          (actor) => actor['actor_id'] == actors[index]['actor_id']);
    }

    update();
  }

  Future<void> submitScene() async {
    if (selectedActorList.isEmpty) {
      Get.snackbar('خطأ', 'يجب اختيار ممثلين للمشهد.');
      return;
    }

    try {
      String? token = await AuthController().getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Token is missing. Please log in again.');
        return;
      }

      List<Map<String, int>> actorIds = selectedActorList.map((actor) {
        return {"actor_id": actor["actor_id"] as int};
      }).toList();

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/scene/$sceneId/actors'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"actors": actorIds}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        Get.snackbar('نجاح', responseData['message']);
        print(responseData['message']);
      } else {
        Get.snackbar('خطأ', 'فشل في إضافة الممثلين إلى المشهد.');
        print('Error: ${response.body}');
      }
    } catch (e) {
      print("Error submitting scene actors: $e");
      Get.snackbar('خطأ', 'حدث خطأ أثناء إرسال البيانات.');
    }
  }

  void addActor() {
    print("Add actor tapped");
  }
}
