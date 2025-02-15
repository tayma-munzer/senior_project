import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Director/artwork_details/editartworkView.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'artwork_details_controller.dart';

class ArtworkDetailsView extends StatelessWidget {
  ArtworkDetailsView({Key? key}) : super(key: key) {
    if (Get.isRegistered<ArtworkDetailsController>()) {
      Get.delete<ArtworkDetailsController>();
    }
    Get.create<ArtworkDetailsController>(() => ArtworkDetailsController());
  }

  @override
  Widget build(BuildContext context) {
    final ArtworkDetailsController controller =
        Get.find<ArtworkDetailsController>();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Obx(() => CustomText(
                    text: controller.artworkTitle.value,
                    fontSize: 25,
                    color: Colors.black,
                    alignment: Alignment.center,
                  )),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Get.toNamed('/addactorstoartwork',
                          arguments: {'artworkId': controller.artworkId});
                    },
                  ),
                  CustomText(
                    text: "الممثلين",
                    fontSize: 18,
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.actors.isEmpty) {
                  return CustomText(
                    text: "لا يوجد ممثلين",
                    fontSize: 16,
                    alignment: Alignment.center,
                  );
                }
                return Column(
                  children: controller.actors.map((actor) {
                    return Card(
                      color: darkgray,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: primaryColor),
                              onPressed: () {
                                controller.deleteActor(actor);
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomText(
                                  text: "${actor.firstName} ${actor.lastName}",
                                  fontSize: 16,
                                  alignment: Alignment.centerRight,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
              SizedBox(height: 20),
              // Scenes Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Get.toNamed('/addlocationtoartwork',
                          arguments: {'artworkId': controller.artworkId});
                    },
                  ),
                  CustomText(
                    text: "المشاهد",
                    fontSize: 18,
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.scenes.isEmpty) {
                  return CustomText(
                    text: "لا يوجد مشاهد",
                    fontSize: 16,
                    alignment: Alignment.center,
                  );
                }
                return Column(
                  children: controller.scenes.map((scene) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/getscenedetails',
                            arguments: {'scene_id': scene.id});
                      },
                      child: Card(
                        color: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(
                            text: scene.title,
                            fontSize: 16,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                  0,
                  0,
                ),
                items: [
                  PopupMenuItem(
                    child: Text("حذف العمل الفني"),
                    value: "delete",
                  ),
                  PopupMenuItem(
                    child: Text("تعديل العمل الفني"),
                    value: "edit",
                  ),
                  PopupMenuItem(
                    child: Text("انهاء العمل"),
                    value: "finish",
                  ),
                ],
              ).then((value) {
                if (value == "delete") {
                  _deleteArtwork(controller);
                } else if (value == "edit") {
                  _editArtwork(controller);
                } else if (value == "finish") {
                  _finishArtwork(controller);
                }
              });
            },
            child: Icon(Icons.settings, color: Colors.white),
            backgroundColor: primaryColor,
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                  0,
                  0,
                ),
                items: [
                  PopupMenuItem(
                    child: Text("اضافة كروما"),
                    value: "chroma",
                  ),
                  PopupMenuItem(
                    child: Text("محاكاة الكلام"),
                    value: "speech",
                  ),
                  PopupMenuItem(
                    child: Text("توليد اعلان"),
                    value: "ad",
                  ),
                  PopupMenuItem(
                    child: Text("ستوري بورد"),
                    value: "storyboard",
                  ),
                  PopupMenuItem(
                    child: Text("موقع الكميرا"),
                    value: "camera",
                  ),
                ],
              ).then((value) {
                if (value == "chroma") {
                  Get.toNamed('/chroma');
                } else if (value == "speech") {
                  Get.toNamed('/lipsync');
                } else if (value == "ad") {
                  Get.toNamed('/trailergenerator');
                } else if (value == "storyboard") {
                  Get.toNamed('/storyboard');
                } else if (value == "camera") {
                  Get.toNamed('/camera');
                }
              });
            },
            child: Icon(Icons.android, color: Colors.white),
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  void _deleteArtwork(ArtworkDetailsController controller) {
    Get.defaultDialog(
      title: "حذف العمل الفني",
      middleText: "هل أنت متأكد من حذف هذا العمل الفني؟",
      textConfirm: "نعم",
      textCancel: "لا",
      onConfirm: () async {
        await controller.deleteArtwork();
      },
    );
  }

  void _editArtwork(ArtworkDetailsController controller) {
    Get.to(
      () => EditArtworkView(),
      arguments: {
        'artworkId': controller.artworkId,
        'artworkTitle': controller.artworkTitle.value,
      },
    );
  }

  void _finishArtwork(ArtworkDetailsController controller) {
    Get.defaultDialog(
      title: "انهاء العمل",
      middleText: "هل أنت متأكد من انهاء هذا العمل؟",
      textConfirm: "نعم",
      textCancel: "لا",
      onConfirm: () async {
        await controller.finishArtwork();
      },
    );
  }
}
