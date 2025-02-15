import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottomappbar_actor.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'director_profile_controller.dart';

class DirectorProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DirectorProfileController controller =
        Get.find<DirectorProfileController>();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    controller.isEditing.value
                        ? EditableProfileField(
                            title: "الاسم الأول",
                            controller: controller.firstNameController,
                          )
                        : ProfileInfoItem(
                            title: "الاسم الأول",
                            value: controller.firstName.value,
                          ),
                    controller.isEditing.value
                        ? EditableProfileField(
                            title: "الاسم الأخير",
                            controller: controller.lastNameController,
                          )
                        : ProfileInfoItem(
                            title: "الاسم الأخير",
                            value: controller.lastName.value,
                          ),
                    controller.isEditing.value
                        ? EditableProfileField(
                            title: "البريد الإلكتروني",
                            controller: controller.emailController,
                          )
                        : ProfileInfoItem(
                            title: "البريد الإلكتروني",
                            value: controller.email.value,
                          ),
                    controller.isEditing.value
                        ? EditableProfileField(
                            title: "رقم الهاتف",
                            controller: controller.phoneNumberController,
                          )
                        : ProfileInfoItem(
                            title: "رقم الهاتف",
                            value: controller.phoneNumber.value,
                          ),
                    controller.isEditing.value
                        ? EditableProfileField(
                            title: "رقم الهاتف الأرضي",
                            controller: controller.landlineNumberController,
                          )
                        : ProfileInfoItem(
                            title: "رقم الهاتف الأرضي",
                            value: controller.landlineNumber.value,
                          ),

                    // "حفظ" button appears only in edit mode
                    if (controller.isEditing.value)
                      Align(
                        alignment: Alignment.center,
                        child: CustomButton(
                          text: "حفظ",
                          onPressed: controller.updateUserProfile,
                        ),
                      ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.toggleEditing,
        backgroundColor: Colors.blue,
        child: Obx(() => Icon(
              controller.isEditing.value ? Icons.close : Icons.edit,
              color: Colors.white,
            )),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

// Profile info display component
class ProfileInfoItem extends StatelessWidget {
  final String title;
  final String value;

  ProfileInfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomText(
            text: title,
            fontSize: 18,
            alignment: Alignment.centerRight,
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: CustomText(
              text: value.isNotEmpty ? value : "غير متوفر",
              fontSize: 16,
              color: Colors.black54,
              alignment: Alignment.centerRight,
            ),
          ),
        ],
      ),
    );
  }
}

// Editable text field component
class EditableProfileField extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  EditableProfileField({required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomText(
            text: title,
            fontSize: 18,
            alignment: Alignment.centerRight,
          ),
          SizedBox(height: 4),
          TextField(
            controller: controller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
