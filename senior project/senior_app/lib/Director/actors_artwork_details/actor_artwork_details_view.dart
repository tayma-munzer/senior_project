import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Director/actor_details/actor_details_controller.dart';
import 'package:senior_app/Director/actors_artwork_details/actor_artwork_details_controller.dart';
import 'package:senior_app/Director/add_actors_to_artwork/add_actors_to_Artwork_controller.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/Director/view_actors/view_actors_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_drawer.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:intl/intl.dart';

class ActorArtworkDetailsView extends StatelessWidget {
  final ActorArtworkDetailsController controller = Get.find();
  final AddActorsToArtworkController actorsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background2.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Obx(() {
                    final personalImage = controller.actor['personal_image'];
                    return Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              "http://10.0.2.2:8000${personalImage ?? '/media/default.jpg'}",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 16),
                  Obx(() {
                    final firstName = controller.actor['first_name'] ?? '';
                    final lastName = controller.actor['last_name'] ?? '';
                    return Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text: '$firstName $lastName',
                        fontSize: 26,
                        color: primaryColor,
                        alignment: Alignment.centerRight,
                      ),
                    );
                  }),
                  SizedBox(height: 16),
                  Obx(() {
                    final country = controller.actor['country'] ?? 'Unknown';
                    return Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text: "$country :الدولة الحالية ",
                        fontSize: 20,
                        color: Colors.black,
                        alignment: Alignment.centerRight,
                      ),
                    );
                  }),
                  SizedBox(height: 15),
                  Obx(() {
                    final phoneNumber =
                        controller.actor['phone_number'] ?? 'غير متوفر';
                    return Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text: "رقم الهاتف: $phoneNumber",
                        fontSize: 20,
                        color: Colors.black,
                        alignment: Alignment.centerRight,
                      ),
                    );
                  }),
                  SizedBox(height: 15),
                  Obx(() {
                    final landlineNumber =
                        controller.actor['landline_number'] ?? 'غير متوفر';
                    return Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text: "رقم الهاتف الأرضي: $landlineNumber",
                        fontSize: 20,
                        color: Colors.black,
                        alignment: Alignment.centerRight,
                      ),
                    );
                  }),
                  SizedBox(height: 15),
                  CustomText(
                    text:
                        'تاريخ الميلاد: ${_getFormattedBirthDate(controller.actor['date_of_birth'])}',
                    fontSize: 20,
                    alignment: Alignment.centerRight,
                  ),
                  SizedBox(height: 15),
                  Obx(() {
                    final age =
                        _calculateAge(controller.actor['date_of_birth']);
                    return Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text: "العمر: $age سنة",
                        fontSize: 20,
                        color: Colors.black,
                        alignment: Alignment.centerRight,
                      ),
                    );
                  }),
                  SizedBox(height: 15),
                  Obx(() {
                    final availability =
                        controller.actor['availability'] == true
                            ? 'متوفر'
                            : 'غير متوفر';
                    final availabilityColor =
                        controller.actor['availability'] == true
                            ? Colors.green
                            : Colors.red;
                    return Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text: availability,
                        fontSize: 22,
                        color: availabilityColor,
                        alignment: Alignment.centerRight,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  String _getFormattedBirthDate(String? date) {
    if (date == null) return "غير متوفر";
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      print("Error parsing birth date: $e");
      return "غير متوفر";
    }
  }

  String _calculateAge(String? date) {
    if (date == null) return "غير متوفر";
    try {
      DateTime birthDate = DateTime.parse(date);
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthDate.year;

      print(
          "Birth Date: $birthDate, Current Year: ${currentDate.year}, Age: $age");

      return age.toString();
    } catch (e) {
      print("Error calculating age: $e");
      return "غير متوفر";
    }
  }
}
