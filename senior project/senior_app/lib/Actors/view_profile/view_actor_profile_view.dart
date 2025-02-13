import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'view_actor_profile_controller.dart';

class ViewActorProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ViewActorProfileController>();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.userProfile.isEmpty) {
          return Center(child: Text('Failed to load profile'));
        }

        var user = controller.userProfile;
        var additionalInfo = user['additional_info'] ?? {};
        var imageUrl =
            'http://10.0.2.2:8000' + (additionalInfo['personal_image'] ?? '');

        String birthDate = "غير متوفر";
        if (additionalInfo['date_of_birth'] != null) {
          DateTime parsedDate = DateTime.parse(additionalInfo['date_of_birth']);
          birthDate = DateFormat('dd-MM-yyyy').format(parsedDate);
        }

        String currentCountry = "غير متوفر";
        if (additionalInfo['current_country'] != null &&
            additionalInfo['current_country']['country'] != null) {
          currentCountry = additionalInfo['current_country']['country'];
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(imageUrl),
              ),
              SizedBox(height: 16),
              CustomText(
                text: '${user['first_name']} : الاسم الاول ',
                fontSize: 20,
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 10),
              CustomText(
                text: ' ${user['last_name']} : اسم العائلة',
                fontSize: 20,
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 8),
              CustomText(
                text: ' ${user['email']} : البريد الالكتروني',
                fontSize: 20,
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 8),
              CustomText(
                text: 'رقم الهاتف: ${user['phone_number']}',
                fontSize: 20,
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 8),
              CustomText(
                text: 'الهاتف الأرضي: ${user['landline_number']}',
                fontSize: 20,
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 8),
              CustomText(
                text:
                    '${additionalInfo['current_country']['contry']} : الدولة الحالية',
                fontSize: 20,
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 8),
              CustomText(
                text: 'تاريخ الميلاد: $birthDate',
                fontSize: 20,
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 8),
              Obx(() {
                return CustomText(
                  text: 'التوفر: ${controller.availability.value}',
                  fontSize: 20,
                  color: primaryColor,
                  alignment: Alignment.centerRight,
                );
              }),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
                MediaQuery.of(context).size.width - 50,
                MediaQuery.of(context).size.height - 150,
                20,
                20),
            items: [
              PopupMenuItem(
                child: CustomText(
                  text: 'تعديل التوافر',
                  fontSize: 16,
                  alignment: Alignment.centerRight,
                ),
                value: 'availability',
              ),
              PopupMenuItem(
                child: CustomText(
                  text: 'تعديل المعلومات الأساسية',
                  fontSize: 16,
                  alignment: Alignment.centerRight,
                ),
                value: 'basic_info',
              ),
              PopupMenuItem(
                child: CustomText(
                  text: 'تعديل الدولة الحالية',
                  fontSize: 16,
                  alignment: Alignment.centerRight,
                ),
                value: 'current_country',
              ),
            ],
          ).then((value) {
            if (value != null) {
              handleMenuSelection(value, context);
            }
          });
        },
        child: Icon(Icons.build),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  void handleMenuSelection(String value, BuildContext context) {
    final controller = Get.find<ViewActorProfileController>();

    if (value == 'availability') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('الى ماذا تريد تغير توافريتك'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('متوفر'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _confirmUpdateAvailability(context, controller, true);
                  },
                ),
                ListTile(
                  title: Text('غير متوفر'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _confirmUpdateAvailability(context, controller, false);
                  },
                ),
              ],
            ),
          );
        },
      );
    } else if (value == 'basic_info') {
      print('editing basic info...');
    } else if (value == 'current_country') {
      print('editing current country...');
    }
  }

  void _confirmUpdateAvailability(BuildContext context,
      ViewActorProfileController controller, bool available) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد العملية'),
          content: Text(
              'هل أنت متأكد من تغيير توافريتك إلى ${available ? 'متوفر' : 'غير متوفر'}؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await controller.updateAvailability(available);
              },
              child: Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }
}
