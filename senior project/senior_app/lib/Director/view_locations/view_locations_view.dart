import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/Director/view_locations/view_locations_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_drawer.dart';

class ViewLocationsView extends StatelessWidget {
  final ViewLocationsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () => _showFilterDialog(context),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      controller.searchQuery.value = value;
                    },
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "ابحث",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Image.asset(
                "assets/locations.webp",
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final locations = controller.filteredLocation();
              if (locations.isEmpty) {
                return Center(child: Text("No locations found."));
              }
              return ListView.builder(
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  return _buildLocationCard(location);
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final ViewLocationsController controller = Get.find();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Building Style",
                  ),
                  onChanged: (value) {
                    controller.buildingStyle.value = value;
                  },
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Building Type",
                  ),
                  onChanged: (value) {
                    controller.buildingType.value = value;
                  },
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("الغاء"),
            ),
            TextButton(
              onPressed: () {
                controller.fetchLocations(
                  buildingStyle: controller.buildingStyle.value,
                  buildingType: controller.buildingType.value,
                );
                Navigator.pop(context);
              },
              child: Text("تطبيق"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLocationCard(Map location) {
    return GestureDetector(
      onTap: () {
        if (location['id'] != null) {
          Get.toNamed('/locationdetails', arguments: location);
        } else {
          print('Location details are missing.');
        }
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Obx(() {
                final isFavorite =
                    controller.favoriteController.isFavorite(location);
                return GestureDetector(
                  onTap: () => controller.toggleFavorite(location),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                );
              }),
              SizedBox(width: 20),
              Container(
                width: 150,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(
                        "http://10.0.2.2:8000${location['photo'] ?? '/media/images/default_location.jpg'}"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      location['location'] ?? 'Unknown',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${location['building_style']?['building_style'] ?? 'Unknown Style'} : نوع البناء",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "${location['detailed_address'] ?? 'No description'}:عنوان البناء",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      "${location['building_owner']['first_name']} ${location['building_owner']['last_name']}: المالك",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
