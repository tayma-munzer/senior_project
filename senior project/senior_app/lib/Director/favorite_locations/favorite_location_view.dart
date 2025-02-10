import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_drawer.dart';
import 'favorite_location_controller.dart';

class FavoriteLocationView extends StatelessWidget {
  final FavoriteLocationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Obx(() {
        if (controller.favoriteLocations.isEmpty) {
          return Center(child: Text("No favorite locations added."));
        }
        return ListView.builder(
          itemCount: controller.favoriteLocations.length,
          itemBuilder: (context, index) {
            final location = controller.favoriteLocations[index];
            return Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await controller.deleteFavorite(location);
                  },
                ),
                title: Text(
                  location['location'] ?? 'Unknown',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  location['detailed_address'] ?? 'No description',
                  textAlign: TextAlign.right,
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
