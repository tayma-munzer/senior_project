import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'view_filming_locations_owner_controller.dart';

class ViewOwnerFilmingLocationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ViewOwnerFilmingLocationController>();

    return Scaffold(
      appBar: AppBar(title: Text("معرض مواقعي")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.locations.isEmpty) {
          return Center(child: CustomText(text: "لا توجد مواقع حالياً"));
        }
        return ListView.builder(
          itemCount: controller.locations.length,
          itemBuilder: (context, index) {
            final location = controller.locations[index];

            final photo = location['photo'] is String ? location['photo'] : '';
            final locationName = location['location'] is String
                ? location['location']
                : 'Unknown Location';
            final detailedAddress = location['detailed_address'] is String
                ? location['detailed_address']
                : 'No Address';
            final buildingStyle = location['building_style'] is String
                ? location['building_style']
                : 'Unknown Style';

            return Card(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 100,
                    child: Image(
                      image: NetworkImage("http://10.0.2.2:8000" + photo),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: locationName,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        CustomText(
                          text: detailedAddress,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        CustomText(
                          text: buildingStyle,
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
