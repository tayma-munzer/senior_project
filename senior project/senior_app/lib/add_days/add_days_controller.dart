import 'package:get/get.dart';

class AddDaysController extends GetxController {
  var selectedDays = <DateTime>[].obs;

  void toggleDay(DateTime day) {
    final dayWithoutTime = DateTime(day.year, day.month, day.day);

    if (selectedDays.contains(dayWithoutTime)) {
      selectedDays.remove(dayWithoutTime);
    } else {
      selectedDays.add(dayWithoutTime);
    }
  }

  void submitDays() {
    if (selectedDays.isEmpty) {
      print("No days selected.");
    } else {
      print("Selected Days:");
      for (var day in selectedDays) {
        print(day.toIso8601String());
      }
    }
  }
}
