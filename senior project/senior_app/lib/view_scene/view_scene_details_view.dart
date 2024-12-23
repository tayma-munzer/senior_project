import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:table_calendar/table_calendar.dart';

class ViewSceneDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve data passed from previous views (with null checks)
    final args = Get.arguments;

    final sceneName = args?['sceneName'] ?? 'اسم المشهد غير متوفر';
    final selectedActors = args?['selectedActors'] ?? [];
    final selectedLocation = args?['selectedLocation'] ?? {};
    final selectedDays = args?['selectedDays'] ?? [];

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        // Wrap the whole body with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Scene Name
            CustomText(
              text: sceneName,
              fontSize: 24,
              alignment: Alignment.topRight,
            ),
            SizedBox(height: 20),

            // Display Selected Actors
            CustomText(
              text: "الممثلين المختارين:",
              fontSize: 20,
              alignment: Alignment.topRight,
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true, // Prevents it from taking too much space
              itemCount: selectedActors.length,
              itemBuilder: (context, index) {
                final actor = selectedActors[index];
                return Card(
                  elevation: 6,
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundImage:
                              AssetImage(actor['image'] ?? 'assets/login.png'),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: actor['name'] ?? 'اسم غير متوفر',
                                fontSize: 18,
                                alignment: Alignment.topRight,
                              ),
                              SizedBox(height: 8),
                              CustomText(
                                text: "العمر: ${actor['age']}",
                                fontSize: 16,
                                alignment: Alignment.topRight,
                              ),
                              CustomText(
                                text: "نوع التمثيل: ${actor['type']}",
                                fontSize: 16,
                                alignment: Alignment.topRight,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Display Selected Location
            CustomText(
              text:
                  "الموقع المختار: ${selectedLocation['name'] ?? 'موقع غير متوفر'}",
              fontSize: 20,
              alignment: Alignment.topRight,
            ),
            SizedBox(height: 10),
            CustomText(
              text:
                  "العنوان: ${selectedLocation['address'] ?? 'عنوان غير متوفر'}",
              fontSize: 18,
              alignment: Alignment.topRight,
            ),
            CustomText(
              text:
                  "نوع الموقع: ${selectedLocation['type'] ?? 'نوع الموقع غير متوفر'}",
              fontSize: 18,
              alignment: Alignment.topRight,
            ),
            SizedBox(height: 20),

            // Display Calendar
            CustomText(
              text: "التواريخ المختارة:",
              fontSize: 20,
              alignment: Alignment.topRight,
            ),
            SizedBox(height: 10),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 365)),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return selectedDays.contains(day);
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
            ),
            SizedBox(height: 20),
            CustomButton(
              text: "موافق",
              onPressed: () {
                // Handle the final confirmation action here
                Get.back();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
