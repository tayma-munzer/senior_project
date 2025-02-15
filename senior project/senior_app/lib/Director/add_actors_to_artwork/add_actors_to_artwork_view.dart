import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Director/add_actors_to_artwork/add_actors_to_Artwork_controller.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_drawer.dart';
import 'package:senior_app/widgets/custom_button.dart';

class AddActorsToArtworkView extends StatefulWidget {
  @override
  _AddActorsToArtworkViewState createState() => _AddActorsToArtworkViewState();
}

class _AddActorsToArtworkViewState extends State<AddActorsToArtworkView> {
  final AddActorsToArtworkController controller = Get.find();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final artworkId = Get.arguments;
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          Expanded(
            child: Obx(() {
              final actors = controller.filteredActors();
              if (actors.isEmpty) {
                return Center(child: Text("No actors found."));
              }
              return ListView.builder(
                itemCount: actors.length,
                itemBuilder: (context, index) {
                  final actor = actors[index];
                  return _buildActorCard(actor);
                },
              );
            }),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                errorText!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: "التالي",
              onPressed: () {
                _submitSelectedActors(artworkId);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildActorCard(Map actor) {
    return Obx(() {
      bool isSelected = controller.selectedActorIds.contains(actor['id']);
      int? selectedRoleId = controller.selectedRoles[actor['id']];
      String roleName = "";

      if (selectedRoleId != null) {
        var role = controller.roleTypes.firstWhere(
          (role) => role['id'] == selectedRoleId,
          orElse: () => <String, dynamic>{},
        );
        if (role.isNotEmpty) {
          roleName = role['role_type'];
        }
      }

      return GestureDetector(
        onTap: () {
          Get.toNamed('/actorsdetailsartwork', arguments: actor);
        },
        child: Card(
          color: isSelected ? Colors.green[300] : Colors.white,
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
                      image: NetworkImage(
                          "http://10.0.2.2:8000${actor['personal_image']}"),
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
                        '${actor['first_name']} ${actor['last_name']}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        actor['availability'] ? "متوفر" : "غير متوفر",
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              actor['availability'] ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (selectedRoleId != null)
                        Text(
                          "الدور: $roleName",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: () {
                          if (isSelected) {
                            controller.deselectActor(actor['id']);
                          } else {
                            _showRoleSelectionDialog(actor);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isSelected ? Colors.green[700] : primaryColor,
                        ),
                        child: Text(
                          isSelected ? "إلغاء التحديد" : "اختر",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showRoleSelectionDialog(Map actor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("اختر نوع التمثيل لهذا الممثل"),
          content: Obx(() {
            if (controller.roleTypes.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: ListBody(
                children: controller.roleTypes.map((roleType) {
                  return ListTile(
                    title: Text(roleType['role_type']),
                    onTap: () {
                      controller.selectRoleForActor(
                          actor['id'], roleType['id']);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            );
          }),
        );
      },
    );
  }

  void _submitSelectedActors(dynamic artworkId) async {
    if (controller.selectedRoles.isEmpty) {
      setState(() {
        errorText = "يجب اختيار ممثل واحد على الاقل";
      });
      return;
    }
    setState(() {
      errorText = null;
    });
    await controller.submitActorsForArtwork(artworkId);
  }
}
