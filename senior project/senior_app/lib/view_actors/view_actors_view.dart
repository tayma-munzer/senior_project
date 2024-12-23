import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/view_actors/view_actors_controller.dart';
import 'package:senior_app/view_locations/view_locations_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_drawer.dart';

class ViewActorsView extends StatelessWidget {
  final ViewActorsController controller = Get.find();

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
              final actor = controller.filteredActors();
              if (actor.isEmpty) {
                return Center(child: Text("No actors found."));
              }
              return ListView.builder(
                itemCount: actor.length,
                itemBuilder: (context, index) {
                  final actors = actor[index];
                  return _builActorsCard(actors);
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _builActorsCard(Map actors) {
    final bool isSelected = controller.isActorSelected(actors);

    return GestureDetector(
      onTap: () {
        Get.toNamed('/actorsdetails', arguments: actors);
      },
      child: Card(
        color: isSelected ? primaryColor : whiteColor,
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image:
                        AssetImage(actors['images']?[0] ?? 'assets/login.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      actors['name'] ?? 'Unknown',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${actors['age'] ?? 'Unknown'}: العمر ",
                      style: TextStyle(fontSize: 14),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            actors['acting_type'] ?? ': نوع التمثيل',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
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