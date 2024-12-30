import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'favorite_location_controller.dart';

class FavoriteLocationView extends StatelessWidget {
  final FavoriteLocationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Locations"),
      ),
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
                title: Text(location['location'] ?? 'Unknown'),
                subtitle:
                    Text(location['detailed_address'] ?? 'No description'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.removeFavorite(location);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
