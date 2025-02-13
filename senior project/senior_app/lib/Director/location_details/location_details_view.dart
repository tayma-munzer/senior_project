import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/Director/location_details/location_details_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_drawer.dart';
import 'package:senior_app/widgets/custom_text.dart';

class ViewLocationDetailsView extends StatelessWidget {
  final ViewLocationDetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(() {
                  if (controller.photos.isEmpty) {
                    return Center(
                      child: Text("No photos available."),
                    );
                  }
                  return SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: controller.pageController,
                      itemCount: controller.photos.length,
                      itemBuilder: (context, index) {
                        final photo = controller.photos[index]['photo'];
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(
                                "http://10.0.2.2:8000$photo",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: controller.previousPage,
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: controller.nextPage,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Location details
                Obx(() => Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text: controller.location['location'] ??
                            'Unknown Location',
                        fontSize: 24,
                        color: primaryColor,
                        alignment: Alignment.topRight,
                      ),
                    )),
                SizedBox(height: 8),
                Obx(() => Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text:
                            " ${controller.location['detailed_address'] ?? 'Unknown Address'} : العنوان المفصل",
                        fontSize: 18,
                        color: Colors.black,
                        alignment: Alignment.topRight,
                      ),
                    )),
                SizedBox(height: 8),
                Obx(() => Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text:
                            " ${controller.location['desc'] ?? 'No description available.'} : الوصف",
                        fontSize: 18,
                        color: Colors.black,
                        alignment: Alignment.topRight,
                      ),
                    )),
                SizedBox(height: 8),
                Obx(() => Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text:
                            " ${controller.location['building_style']?['building_style'] ?? 'Unknown Style'} :تصميم البناء",
                        fontSize: 18,
                        color: Colors.black,
                        alignment: Alignment.topRight,
                      ),
                    )),
                SizedBox(height: 8),
                Obx(() => Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text:
                            " ${controller.location['building_type']?['building_type'] ?? 'Unknown Type'} :نوع البناء",
                        fontSize: 18,
                        color: Colors.black,
                        alignment: Alignment.topRight,
                      ),
                    )),
                SizedBox(height: 16),
                CustomText(
                  text: "  معلومات صاحب الموقع",
                  fontSize: 22,
                  color: lightblue,
                  alignment: Alignment.centerRight,
                ),
                SizedBox(height: 8),
                Obx(() => Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text:
                            " ${controller.location['building_owner']?['first_name']} ${controller.location['building_owner']?['last_name']} : الاسم",
                        fontSize: 18,
                        color: Colors.black,
                        alignment: Alignment.topRight,
                      ),
                    )),
                SizedBox(height: 8),
                Obx(() => Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text:
                            " ${controller.location['building_owner']?['email']} : البريد الالكتروني",
                        fontSize: 18,
                        color: Colors.black,
                        alignment: Alignment.topRight,
                      ),
                    )),
                SizedBox(height: 8),
                Obx(() => Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text:
                            " ${controller.location['building_owner']?['phone_number']} : رقم الهاتف",
                        fontSize: 18,
                        color: Colors.black,
                        alignment: Alignment.topRight,
                      ),
                    )),
                SizedBox(height: 8),
                Obx(() => Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text:
                            " ${controller.location['building_owner']?['landline_number']} : رقم الهاتف الارضي",
                        fontSize: 18,
                        color: Colors.black,
                        alignment: Alignment.topRight,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
