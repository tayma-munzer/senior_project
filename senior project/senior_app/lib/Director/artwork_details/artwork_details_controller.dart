import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:senior_app/auth_controller.dart';

class ArtworkDetailsController extends GetxController {
  var actors = <Actor>[].obs;
  var scenes = <Scene>[].obs;
  var isLoading = false.obs;
  late int artworkId;
  var artworkTitle = ''.obs;

  @override
  void onInit() {
    final Map<String, dynamic> args = Get.arguments;
    artworkId = args['artworkId'];
    artworkTitle.value = args['artworkTitle'];
    fetchActors();
    fetchScenes();
    super.onInit();
  }

  Future<void> fetchActors() async {
    try {
      isLoading(true);
      String? token = await AuthController().getToken();
      if (token == null) {
        print("Error: User token is null");
        return;
      }
      var response = await http.get(
        Uri.parse('http://10.0.2.2:8000/artwork/$artworkId/actors'),
        headers: {'Authorization': 'Token $token'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        actors.value = data.map((item) {
          return Actor(
            id: item['actor']['id'],
            firstName: item['actor']['first_name'],
            lastName: item['actor']['last_name'],
          );
        }).toList();
      } else {
        print("Error fetching actors: ${response.body}");
      }
    } catch (e) {
      print("Exception while fetching actors: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchScenes() async {
    try {
      isLoading(true);
      String? token = await AuthController().getToken();
      if (token == null) {
        print("Error: User token is null");
        return;
      }
      var response = await http.get(
        Uri.parse('http://10.0.2.2:8000/artwork/$artworkId/scenes'),
        headers: {'Authorization': 'Token $token'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        scenes.value = data.map((item) {
          return Scene(
            id: item['id'],
            title: item['title'],
          );
        }).toList();
      } else {
        print("Error fetching scenes: ${response.body}");
      }
    } catch (e) {
      print("Exception while fetching scenes: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteArtwork() async {
    try {
      isLoading(true);
      String? token = await AuthController().getToken();
      if (token == null) {
        print("Error: User token is null");
        return;
      }
      var response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/artwork/$artworkId'),
        headers: {'Authorization': 'Token $token'},
      );
      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar("تم الحذف", "تم حذف العمل الفني بنجاح");
        Get.offAllNamed('/directorHome');
      } else {
        print("Error deleting artwork: ${response.body}");
        Get.snackbar("خطأ", "فشل في حذف العمل الفني");
      }
    } catch (e) {
      print("Exception while deleting artwork: $e");
      Get.snackbar("خطأ", "حدث خطأ أثناء حذف العمل الفني");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateArtwork(
      {required String title, required File poster}) async {
    try {
      isLoading(true);
      String? token = await AuthController().getToken();
      if (token == null) {
        print("Error: User token is null");
        return;
      }

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('http://10.0.2.2:8000/artwork/$artworkId'),
      );

      request.headers['Authorization'] = 'Token $token';
      request.fields['title'] = title;

      request.files.add(
        await http.MultipartFile.fromPath(
          'poster',
          poster.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar("تم التعديل", "تم تعديل العمل الفني بنجاح");
        artworkTitle.value = title;
      } else {
        print(
            "Error updating artwork: ${await response.stream.bytesToString()}");
        Get.snackbar("خطأ", "فشل في تعديل العمل الفني");
      }
    } catch (e) {
      print("Exception while updating artwork: $e");
      Get.snackbar("خطأ", "حدث خطأ أثناء تعديل العمل الفني");
    } finally {
      isLoading(false);
    }
  }

  void deleteActor(Actor actor) {
    actors.remove(actor);
  }

  void deleteScene(Scene scene) {
    scenes.remove(scene);
  }
}

class Actor {
  final int id;
  final String firstName;
  final String lastName;
  Actor({required this.id, required this.firstName, required this.lastName});
}

class Scene {
  final int id;
  final String title;
  Scene({required this.id, required this.title});
}
