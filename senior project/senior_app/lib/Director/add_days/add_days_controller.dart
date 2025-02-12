import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senior_app/auth_controller.dart';

class AddDaysController extends GetxController {
  var selectedDays = <DateTime>[].obs;
  DateTime? startDate;
  DateTime? endDate;
  late int locationId;
  late String title;
  late int artworkId;

  void toggleDay(DateTime day) {
    final dayWithoutTime = DateTime(day.year, day.month, day.day);

    if (selectedDays.contains(dayWithoutTime)) {
      selectedDays.remove(dayWithoutTime);
    } else {
      selectedDays.add(dayWithoutTime);
    }

    updateStartAndEndDate();
  }

  void updateStartAndEndDate() {
    if (selectedDays.isNotEmpty) {
      selectedDays.sort((a, b) => a.compareTo(b));
      startDate = selectedDays.first;
      endDate = selectedDays.last;
    } else {
      startDate = null;
      endDate = null;
    }
  }

  Future<void> submitDays() async {
    if (selectedDays.isEmpty) {
      print("No days selected.");
    } else {
      String? token = await AuthController().getToken();
      if (token == null) {
        print("Error: User token is null");
        return;
      }

      String formatDate(DateTime? date) {
        if (date == null) return "";
        return "${date.year}-${date.month}-${date.day}";
      }

      var requestBody = {
        "title": title,
        "start_date": formatDate(startDate),
        "end_date": formatDate(endDate),
        "artwork_id": artworkId,
        "location_id": locationId
      };

      var response = await http.post(
        Uri.parse('http://10.0.2.2:8000/scene'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json'
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        print("Scene successfully created: ${response.body}");
        Get.toNamed('/nextStep');
      } else {
        print("Error creating scene: ${response.body}");
      }
    }
  }
}
