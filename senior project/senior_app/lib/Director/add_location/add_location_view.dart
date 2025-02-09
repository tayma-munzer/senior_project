import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'add_location_controller.dart';

class AddLocationView extends StatelessWidget {
  final AddLocationController controller = Get.find<AddLocationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    print("filter icon tapped");
                  },
                  child: Icon(
                    Icons.filter_list,
                    size: 32,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      controller.searchQuery.value = value;
                    },
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "ابحث",
                      prefixIcon: Icon(Icons.search),
                      hintStyle: TextStyle(
                        textBaseline: TextBaseline.alphabetic,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            CustomText(
              text: "اختر موقع تمثيل",
              fontSize: 20,
              alignment: Alignment.bottomRight,
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.locations.length,
                  itemBuilder: (context, index) {
                    final location = controller.locations[index];
                    return GestureDetector(
                      onTap: () {
                        controller.selectLocation(index);
                      },
                      child: Obx(() {
                        final isSelected =
                            controller.selectedLocationIndex.value == index;
                        return Card(
                          elevation: 6,
                          margin:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? Colors.blue : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(location['image'] ??
                                          'assets/location.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text:
                                            location['name'] ?? 'اسم غير متوفر',
                                        fontSize: 18,
                                        color: Colors.black,
                                        alignment: Alignment.bottomRight,
                                      ),
                                      SizedBox(height: 8),
                                      CustomText(
                                        text:
                                            "العنوان: ${location['address'] ?? ''}",
                                        fontSize: 16,
                                        color: Colors.grey,
                                        alignment: Alignment.bottomRight,
                                      ),
                                      CustomText(
                                        text:
                                            " ${location['type']} : نوع الموقع",
                                        fontSize: 16,
                                        color: Colors.grey,
                                        alignment: Alignment.bottomRight,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 16),
            CustomButton(
              text: "التالي",
              onPressed: () {
                controller.submitLocation();
                Get.toNamed('/adddays');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
