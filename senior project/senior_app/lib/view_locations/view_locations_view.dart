import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/view_locations/view_locations_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_drawer.dart';

class ViewLocationsView extends StatelessWidget {
  final ViewLocationsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: () {},
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
          Expanded(
            child: Obx(() {
              final locations = controller.filteredLocations();
              if (locations.isEmpty) {
                return Center(child: Text("No locations found."));
              }
              return ListView.builder(
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  return _buildLocationCard(location, index);
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildLocationCard(Map location, int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/locationdetails', arguments: location);
      },
      child: Card(
        color: whiteColor,
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Row(
                children: [
                  Obx(() {
                    final isFavorite = controller.isFavorite(index);
                    return GestureDetector(
                      onTap: () {
                        controller.toggleFavorite(index);
                        print('Location Name: ${location['location']}');
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    );
                  }),
                  SizedBox(width: 8),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(
                            location['images']?[0] ?? 'assets/login.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      location['location'] ?? 'Unknown',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${location['building_style'] ?? 'Unknown'}: نوع البناء",
                      style: TextStyle(fontSize: 14),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            location['detailed_address'] ?? 'No description',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Text(
                          ": الوصف",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Text(
                      "${location['building_owner']['first_name']} ${location['building_owner']['last_name']}: المالك",
                      style: TextStyle(fontSize: 14),
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
