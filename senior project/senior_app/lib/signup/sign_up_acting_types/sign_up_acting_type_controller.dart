import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpActingTypeController extends GetxController {
  var selectedActingType = ''.obs;
  RxList<String> actingTypes = <String>[].obs;
  var savedActingTypes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchActingTypes();
  }

  Future<void> fetchActingTypes() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/acting_types'));
      if (response.statusCode == 200) {
        //مشان الحروف تصير عربي
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> actingTypeList = json.decode(decodedBody);
        actingTypes.value =
            actingTypeList.map((e) => e['type'] as String).toList();
      } else {
        Get.snackbar('Error', 'Failed to load acting types');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching acting types');
      print(e);
    }
  }

  void saveActingType(String type) {
    if (!savedActingTypes.contains(type)) {
      savedActingTypes.add(type);
    }
  }

  void removeActingType(String type) {
    savedActingTypes.remove(type);
  }

  bool isUserActor() {
    return true;
  }
}
