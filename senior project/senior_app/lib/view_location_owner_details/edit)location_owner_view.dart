// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:senior_app/view_location_owner_details/view_location_details_controller.dart';
// import 'package:senior_app/widgets/custom_text.dart';

// class EditLocationOwnerLocationDetailsView extends StatefulWidget {
//   @override
//   _EditLocationOwnerLocationDetailsViewState createState() =>
//       _EditLocationOwnerLocationDetailsViewState();
// }

// class _EditLocationOwnerLocationDetailsViewState
//     extends State<EditLocationOwnerLocationDetailsView> {
//   final controller = Get.find<ViewLocationOwnerLocationDetailsController>();

//   // Controllers for text fields.
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController descController = TextEditingController();

//   // Dropdown data and selections for building style and type.
//   List<dynamic> buildingStyles = [];
//   List<dynamic> buildingTypes = [];
//   int? selectedBuildingStyleId;
//   int? selectedBuildingTypeId;

//   // We assume building_owner_id remains unchanged.
//   String? buildingOwnerId;

//   // The current location id.
//   late int locationId;

//   @override
//   void initState() {
//     super.initState();
//     // Retrieve locationId from Get.arguments.
//     locationId = Get.arguments['locationId'] ?? 0;
//     if (locationId != 0) {
//       // Prepopulate fields from the existing location details.
//       final details = controller.locationDetails.value;
//       locationController.text = details['location'] ?? '';
//       addressController.text = details['detailed_address'] ?? '';
//       descController.text = details['desc'] ?? '';
//       buildingOwnerId = details['building_owner'] != null
//           ? details['building_owner']['id'].toString()
//           : null;

//       if (details['building_style'] != null) {
//         selectedBuildingStyleId = details['building_style']['id'];
//       }
//       if (details['building_type'] != null) {
//         selectedBuildingTypeId = details['building_type']['id'];
//       }

//       // Fetch dropdown data.
//       fetchDropdownData();
//     } else {
//       Get.snackbar('Error', 'Invalid location ID');
//     }
//   }

//   Future<void> fetchDropdownData() async {
//     buildingStyles = await controller.fetchBuildingStyles();
//     buildingTypes = await controller.fetchBuildingTypes();
//     setState(() {}); // Refresh UI after fetching dropdown data.
//   }

//   @override
//   void dispose() {
//     locationController.dispose();
//     addressController.dispose();
//     descController.dispose();
//     super.dispose();
//   }

//   void _submitForm() async {
//     // Build the update data map.
//     final updateData = {
//       "location": locationController.text,
//       "detailed_address": addressController.text,
//       "desc": descController.text,
//       "building_style_id": selectedBuildingStyleId,
//       "building_type_id": selectedBuildingTypeId,
//       // Include building_owner_id if needed.
//       "building_owner_id": buildingOwnerId,
//     };

//     await controller.updateLocation(updateData, locationId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('تعديل الموقع'),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 CustomText(
//                   text: 'تعديل تفاصيل الموقع',
//                   fontSize: 24,
//                   color: Colors.black,
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: locationController,
//                   decoration: InputDecoration(
//                     labelText: 'اسم الموقع',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: addressController,
//                   decoration: InputDecoration(
//                     labelText: 'تفاصيل العنوان',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: descController,
//                   decoration: InputDecoration(
//                     labelText: 'الوصف',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 3,
//                 ),
//                 SizedBox(height: 10),
//                 // Dropdown for Building Style.
//                 DropdownButtonFormField<int>(
//                   value: selectedBuildingStyleId,
//                   items: buildingStyles.map<DropdownMenuItem<int>>((item) {
//                     return DropdownMenuItem<int>(
//                       value: item['id'],
//                       child: Text(item['building_style'] ?? 'Unknown'),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedBuildingStyleId = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'نمط البناء',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 // Dropdown for Building Type.
//                 DropdownButtonFormField<int>(
//                   value: selectedBuildingTypeId,
//                   items: buildingTypes.map<DropdownMenuItem<int>>((item) {
//                     return DropdownMenuItem<int>(
//                       value: item['id'],
//                       child: Text(item['building_type'] ?? 'Unknown'),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedBuildingTypeId = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'نوع البناء',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _submitForm,
//                   child: Text('تحديث الموقع'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
