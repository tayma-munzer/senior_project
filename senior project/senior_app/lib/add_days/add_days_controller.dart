import 'package:get/get.dart';

class AddDaysController extends GetxController {
  // List to store selected days
  var selectedDays = <DateTime>[].obs;

  // Toggle a day (add or remove from selected list)
  void toggleDay(DateTime day) {
    // Create a new DateTime object with only the date (ignoring time)
    final dayWithoutTime = DateTime(day.year, day.month, day.day);

    if (selectedDays.contains(dayWithoutTime)) {
      selectedDays.remove(dayWithoutTime);
    } else {
      selectedDays.add(dayWithoutTime);
    }
  }

  // Print the selected days
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
