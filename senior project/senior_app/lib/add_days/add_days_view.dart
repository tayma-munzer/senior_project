import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'add_days_controller.dart';

class AddDaysView extends StatelessWidget {
  final AddDaysController controller = Get.find<AddDaysController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "اختر ايام التصوير للمشهد",
              fontSize: 20,
              alignment: Alignment.bottomRight,
            ),
            SizedBox(height: 16),
            Expanded(
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(Duration(days: 365)),
                focusedDay: DateTime.now(),
                selectedDayPredicate: (day) {
                  return controller.selectedDays.any((selectedDay) =>
                      selectedDay.year == day.year &&
                      selectedDay.month == day.month &&
                      selectedDay.day == day.day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  controller.toggleDay(selectedDay);
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),
            SizedBox(height: 16),
            CustomButton(
              text: "التالي",
              onPressed: () {
                controller.submitDays();
                Get.toNamed('/viewscenedetails');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
