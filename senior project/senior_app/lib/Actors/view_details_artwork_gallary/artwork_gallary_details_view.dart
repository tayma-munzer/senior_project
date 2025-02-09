import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Actors/view_details_artwork_gallary/artwork_gallary_details_controller.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_appbar_location.dart';
import 'package:senior_app/widgets/custom_location_bottombar.dart';

class ArtworkGallaryDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ArtworkGallaryDetailsController>();

    return Scaffold(
      appBar: CustomAppBarLocation(),
      body: Obx(() {
        final artwork = controller.artworkDetails;
        if (artwork.isEmpty) {
          return Center(child: CustomText(text: "No details available"));
        }

        final actor = artwork['actor'] ?? {};
        final roleType = artwork['role_type'] ?? {};
        final posterUrl = artwork['poster'] != null
            ? "http://10.0.2.2:8000${artwork['poster']}"
            : null;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (posterUrl != null)
                  Center(
                    child: Image.network(
                      posterUrl,
                      fit: BoxFit.cover,
                      width: 300,
                      height: 200,
                    ),
                  ),
                SizedBox(height: 30),
                CustomText(
                  text:
                      ' ${artwork['artwork_name'] ?? 'غير معروف'} : اسم العمل الفني',
                  fontSize: 24,
                  color: Colors.black,
                  alignment: Alignment.centerRight,
                ),
                SizedBox(height: 10),
                CustomText(
                  text:
                      '${artwork['character_name'] ?? 'غير معروف'} : اسم الشخصية',
                  fontSize: 20,
                  color: Colors.grey,
                  alignment: Alignment.centerRight,
                ),
                SizedBox(height: 10),
                CustomText(
                  text: '${roleType['role_type'] ?? 'غير معروف'} : نوع الدور',
                  fontSize: 20,
                  color: Colors.blue,
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
