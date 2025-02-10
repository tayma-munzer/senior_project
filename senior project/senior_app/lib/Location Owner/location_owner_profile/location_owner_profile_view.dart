import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Location%20Owner/location_owner_profile/location_owner_profile_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';

class LocationOwnerProfileView extends StatelessWidget {
  final LocationOwnerProfileController controller =
      Get.put(LocationOwnerProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.userData.isEmpty) {
          return Center(
              child: Text(
            "لا يوجد بيانات للعرض",
            style: TextStyle(fontSize: 22),
          ));
        }

        final user = controller.userData;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/personal_account.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 20),
              _buildEditableField(
                context: context,
                title: "الاسم الاول",
                field: "first_name",
                value: user['first_name'] ?? "غير متوفر",
              ),
              _buildEditableField(
                context: context,
                title: "اسم العائلة",
                field: "last_name",
                value: user['last_name'] ?? "غير متوفر",
              ),
              _buildEditableField(
                context: context,
                title: "البريد الالكتروني",
                field: "email",
                value: user['email'] ?? "غير متوفر",
              ),
              _buildEditableField(
                context: context,
                title: "رقم الهاتف",
                field: "phone_number",
                value: user['phone_number']?.toString() ?? "غير متوفر",
              ),
              _buildEditableField(
                context: context,
                title: "رقم الهاتف الارضي",
                field: "landline_number",
                value: user['landline_number']?.toString() ?? "غير متوفر",
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildEditableField({
    required BuildContext context,
    required String title,
    required String field,
    required dynamic value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _showEditDialog(context, field, value);
              },
            ),
            Text(
              title,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            value.toString(),
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  void _showEditDialog(BuildContext context, String field, dynamic value) {
    final textController = TextEditingController(text: value?.toString() ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "تعديل $field",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: textController,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: "أدخل $field الجديد",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("إلغاء", style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                Get.find<LocationOwnerProfileController>()
                    .updateProfile(field, textController.text);
                Navigator.pop(context);
              },
              child: Text("حفظ", style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }
}
