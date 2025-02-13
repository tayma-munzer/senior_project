import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'scene_details_controller.dart';

class SceneDetailsView extends StatelessWidget {
  SceneDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SceneDetailsController controller =
        Get.find<SceneDetailsController>();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          final scene = controller.sceneDetails.value;

          if (scene == null) {
            return Center(
                child: CustomText(text: "No scene details available"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: " ${scene.title} : عنوان المشهد",
                  fontSize: 25,
                  alignment: Alignment.centerRight,
                  color: primaryColor,
                ),
                SizedBox(height: 10),
                CustomText(
                  text: " ${scene.sceneNumber} : رقم المشهد",
                  fontSize: 20,
                  alignment: Alignment.centerRight,
                ),
                SizedBox(height: 10),
                CustomText(
                  text: " ${scene.startDate} : تاريخ البدء",
                  fontSize: 20,
                  alignment: Alignment.centerRight,
                ),
                SizedBox(height: 10),
                CustomText(
                  text: "${scene.endDate}: تاريخ الانتهاء",
                  fontSize: 20,
                  alignment: Alignment.centerRight,
                ),
                SizedBox(height: 20),
                CustomText(
                  text: "تفاصيل موقع التصوير ",
                  fontSize: 25,
                  alignment: Alignment.centerRight,
                  color: lightblue,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    controller.toggleDetails();
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(
                                  "http://10.0.2.2:8000${scene.location.photo ?? '/media/images/default_location.jpg'}",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomText(
                            text: " ${scene.location.location}: اسم الموقع",
                            fontSize: 20,
                            alignment: Alignment.centerRight,
                          ),
                          SizedBox(height: 10),
                          CustomText(
                            text: " ${scene.location.detailedAddress}: العنوان",
                            fontSize: 20,
                            alignment: Alignment.centerRight,
                          ),
                          if (controller.showFullDetails.value) ...[
                            SizedBox(height: 10),
                            CustomText(
                              text: "${scene.location.desc} : الوصف",
                              fontSize: 20,
                              alignment: Alignment.centerRight,
                            ),
                            SizedBox(height: 10),
                            CustomText(
                              text:
                                  " ${scene.location.buildingStyle.buildingStyle} : تصميم البناء",
                              fontSize: 20,
                              alignment: Alignment.centerRight,
                            ),
                            SizedBox(height: 10),
                            CustomText(
                              text:
                                  " ${scene.location.buildingType.buildingType}: نمط البناء",
                              fontSize: 20,
                              alignment: Alignment.centerRight,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomText(
                  text: "الممثلين في المشهد",
                  fontSize: 25,
                  alignment: Alignment.centerRight,
                  color: lightblue,
                ),
                SizedBox(height: 10),
                Obx(() {
                  if (controller.sceneActors.isEmpty) {
                    return CustomText(
                      text: "لا يوجد ممثلين في هذا المشهد",
                      fontSize: 20,
                      alignment: Alignment.center,
                    );
                  }
                  return Column(
                    children: controller.sceneActors.map((actor) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          title: CustomText(
                            text: "${actor.firstName} ${actor.lastName}",
                            fontSize: 20,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
                SizedBox(height: 10),
                CustomText(
                  text:
                      " انتهاء المشهد : ${scene.done ? 'منتهي' : 'غير منتهي'}",
                  fontSize: 25,
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showActionMenu(context, controller),
        child: Icon(Icons.build),
        backgroundColor: primaryColor,
      ),
    );
  }

  void _showActionMenu(
      BuildContext context, SceneDetailsController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: CustomText(
                text: "تعديل معلومات المشهد",
                fontSize: 18,
                alignment: Alignment.center,
              ),
              onTap: () {
                controller.editSceneDetails();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: CustomText(
                text: "تعديل حالة المشهد",
                fontSize: 18,
                alignment: Alignment.center,
              ),
              onTap: () {
                controller.toggleSceneStatus();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: CustomText(
                text: "تعديل الموقع",
                fontSize: 18,
                alignment: Alignment.center,
              ),
              onTap: () {
                controller.editLocation();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: CustomText(
                text: "حذف المشهد",
                fontSize: 18,
                alignment: Alignment.center,
              ),
              onTap: () {
                controller.deleteScene();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
