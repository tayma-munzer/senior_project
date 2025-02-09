import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Actors/view_actore_artwork/view_actor_artwork_gallary_controller.dart';
import 'package:senior_app/widgets/custom_appbar_location.dart';
import 'package:senior_app/widgets/custom_location_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';

class ViewActorArtworkGalleryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ViewActorArtworkGallaryController>();

    return Scaffold(
      appBar: CustomAppBarLocation(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.artworks.isEmpty) {
          return Center(child: CustomText(text: "لا توجد اعمال حالياً"));
        }
        return ListView.builder(
          itemCount: controller.artworks.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Image.asset(
                'assets/acors.png',
                width: double.infinity,
                height: 250,
              );
            }

            final artwork = controller.artworks[index - 1];

            final artworkId = artwork['id'] ?? 0;
            final artworkname = artwork['artwork_name'] ?? 'Unknown artwork';
            final characterName =
                artwork['character_name'] ?? 'No character name';
            final roleType =
                artwork['role_type']?['role_type'] ?? 'Unknown role type';
            final posterPath = artwork['poster'] ?? ''; // Ensure it’s not null
            final imageUrl = "http://10.0.2.2:8000$posterPath";

            return GestureDetector(
              onTap: () {
                if (artworkId != 0) {
                  print(
                      'Navigating to ViewactorOwnerartworkgallaryDetailsView with actorId: $artworkId');
                  Get.toNamed(
                    '/artworkdetails',
                    arguments: {'artworkId': artworkId},
                  );
                } else {
                  print('Invalid artwork Id ');
                }
              },
              child: Card(
                margin: EdgeInsets.all(15),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              CustomText(
                                text: artworkname,
                                fontSize: 22,
                                color: Colors.black,
                                alignment: Alignment.centerRight,
                              ),
                              SizedBox(height: 8),
                              CustomText(
                                text: " $characterName  :  اسم الشخصية",
                                fontSize: 18,
                                color: Colors.grey,
                                alignment: Alignment.centerRight,
                              ),
                              CustomText(
                                text: "$roleType  :  نوع الدور",
                                fontSize: 18,
                                color: Colors.blue,
                                alignment: Alignment.centerRight,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: CustomBottomLocationNavBar(),
    );
  }
}
