import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/location_details/location_details_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_drawer.dart';
import 'package:senior_app/widgets/custom_text.dart'; // Import the custom text widgets

class ViewLocationDetailsView extends StatelessWidget {
  final ViewLocationDetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(() {
                  final mediaList = controller.location['images'] ?? [];
                  if (mediaList.isEmpty) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/login.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Container(
                        height: 200,
                        child: PageView.builder(
                          controller: controller.pageController,
                          itemCount: mediaList.length,
                          itemBuilder: (context, index) {
                            final media = mediaList[index];
                            if (media.endsWith('.mp4')) {
                              return Center(
                                child: Icon(
                                  Icons.videocam,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(media),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 8),
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
                    ],
                  );
                }),
                SizedBox(height: 16),
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
