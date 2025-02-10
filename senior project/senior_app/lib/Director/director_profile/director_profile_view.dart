import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Director/director_profile/director_profile_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:http/http.dart' as http;

class DirectorPersonalProfileView extends StatelessWidget {
  final DirectorPersonalProfileController controller =
      Get.put(DirectorPersonalProfileController());

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
              child:
                  Text("لا يوجد بيانات للعرض", style: TextStyle(fontSize: 22)));
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
                value: user['first_name'] ?? "غير متوفر ",
              ),
              _buildEditableField(
                context: context,
                title: "اسم العائلة",
                field: "last_name",
                value: user['last_name'] ?? "غير متوفر ",
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
                value: user['phone_number']?.toString() ?? "Not available",
              ),
              _buildEditableField(
                context: context,
                title: "رقم الهاتف الارضي",
                field: "landline_number",
                value: user['landline_number']?.toString() ?? "Not available",
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
            value != null ? value.toString() : "N/A",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  void _showEditDialog(BuildContext context, String field, dynamic value) {
    final controller = TextEditingController(text: value?.toString() ?? "");

    String dialogTitle = _getDialogTitle(field);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            dialogTitle,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: _getHintText(field),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "إلغاء",
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_validateInput(field, controller.text)) {
                  Get.find<DirectorPersonalProfileController>()
                      .updateProfile(field, controller.text);
                  Navigator.pop(context);
                } else {
                  Get.snackbar(
                    "خطأ",
                    "الرجاء التأكد من المدخلات",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.white,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    borderRadius: 10,
                    messageText: Text(
                      "الرجاء التأكد من المدخلات",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }
              },
              child: Text(
                "حفظ",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getDialogTitle(String field) {
    switch (field) {
      case "first_name":
        return "ادخل الاسم الاول";
      case "last_name":
        return "ادخل اسم العائلة";
      case "email":
        return "ادخل البريد الالكتروني";
      case "phone_number":
        return "ادخل رقم الهاتف";
      case "landline_number":
        return "ادخل رقم الهاتف الثابت";
      default:
        return "تعديل $field";
    }
  }

  String _getHintText(String field) {
    switch (field) {
      case "first_name":
        return "أدخل الاسم الاول الجديد";
      case "last_name":
        return "أدخل اسم العائلة الجديد";
      case "email":
        return "أدخل البريد الالكتروني الجديد";
      case "phone_number":
        return "أدخل رقم الهاتف الجديد";
      case "landline_number":
        return "أدخل رقم الهاتف الثابت الجديد";
      default:
        return "أدخل $field الجديد";
    }
  }

  bool _validateInput(String field, String value) {
    if (value.isEmpty) {
      Get.snackbar(
        "خطأ",
        "لا يجب ترك حقل فارغ",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(15),
        borderRadius: 10,
        messageText: Text(
          "لا يجب ترك حقل فارغ",
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
      return false;
    }

    switch (field) {
      case "email":
        String emailPattern =
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
        RegExp regex = RegExp(emailPattern);
        if (!regex.hasMatch(value)) {
          Get.snackbar(
            "خطأ",
            "البريد الالكتروني غير صالح",
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(15),
            borderRadius: 10,
            messageText: Text(
              "البريد الالكتروني غير صالح",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
          return false;
        }
        break;
      case "phone_number":
        if (!value.startsWith("09") || value.length != 10) {
          Get.snackbar(
            "خطأ",
            "رقم الهاتف يجب أن يبدأ بـ 09 ويتكون من 10 أرقام",
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(15),
            borderRadius: 10,
            messageText: Text(
              "رقم الهاتف يجب أن يبدأ بـ 09 ويتكون من 10 أرقام",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
          return false;
        }
        break;
      case "landline_number":
        if (!value.startsWith("011") || value.length != 10) {
          Get.snackbar(
            "خطأ",
            "رقم الهاتف الثابت يجب أن يبدأ بـ 011 ويتكون من 10 أرقام",
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(15),
            borderRadius: 10,
            messageText: Text(
              "رقم الهاتف الثابت يجب أن يبدأ بـ 011 ويتكون من 10 أرقام",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
          return false;
        }
        break;
      default:
        break;
    }

    return true;
  }
}
