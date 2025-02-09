import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_editable_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditLocationOwnerView extends StatefulWidget {
  @override
  _EditLocationOwnerViewState createState() => _EditLocationOwnerViewState();
}

class _EditLocationOwnerViewState extends State<EditLocationOwnerView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _detailedAddressController =
      TextEditingController();
  final TextEditingController _descController = TextEditingController();

  RxInt selectedBuildingStyleId = 0.obs;
  RxInt selectedBuildingTypeId = 0.obs;

  RxList<dynamic> buildingStyles = <dynamic>[].obs;
  RxList<dynamic> buildingTypes = <dynamic>[].obs;

  RxList<Map<String, dynamic>> photos = <Map<String, dynamic>>[].obs;

  int locationId = 0;

  String buildingOwnerId = "";

  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    locationId = Get.arguments['locationId'] ?? 0;
    if (Get.arguments['locationDetails'] != null &&
        Get.arguments['locationDetails']['building_owner_id'] != null) {
      buildingOwnerId =
          Get.arguments['locationDetails']['building_owner_id'].toString();
    }
    if (locationId != 0) {
      _fetchLocationDetails();
      _fetchBuildingStyles();
      _fetchBuildingTypes();
    } else {
      Get.snackbar('Error', 'Invalid location ID');
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> _fetchLocationDetails() async {
    isLoading.value = true;
    String token = await _getToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/filming_location/$locationId'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _locationController.text = data['location'] ?? '';
      _detailedAddressController.text = data['detailed_address'] ?? '';
      _descController.text = data['desc'] ?? '';
      if (buildingOwnerId.isEmpty && data['building_owner_id'] != null) {
        buildingOwnerId = data['building_owner_id'].toString();
      }
      if (data['building_style'] != null &&
          data['building_style']['id'] != null) {
        selectedBuildingStyleId.value = data['building_style']['id'];
      }
      if (data['building_type'] != null &&
          data['building_type']['id'] != null) {
        selectedBuildingTypeId.value = data['building_type']['id'];
      }
      final photosResponse = await http.get(
        Uri.parse('http://10.0.2.2:8000/location/$locationId/photos'),
        headers: {'Authorization': 'Token $token'},
      );
      if (photosResponse.statusCode == 200) {
        List<dynamic> photosData = json.decode(photosResponse.body);
        photos.value = photosData.map<Map<String, dynamic>>((photoData) {
          return {'id': photoData['id'], 'photo': photoData['photo']};
        }).toList();
      }
    } else {
      Get.snackbar('Error', 'Failed to fetch location details');
    }
    isLoading.value = false;
  }

  Future<void> _fetchBuildingStyles() async {
    String token = await _getToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/building_styles'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      buildingStyles.value = data;
    } else {
      Get.snackbar('Error', 'Failed to fetch building styles');
    }
  }

  Future<void> _fetchBuildingTypes() async {
    String token = await _getToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/building_types'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      buildingTypes.value = data;
    } else {
      Get.snackbar('Error', 'Failed to fetch building types');
    }
  }

  Future<void> _updateLocation() async {
    if (!_formKey.currentState!.validate()) return;
    isLoading.value = true;
    String token = await _getToken();
    final body = json.encode({
      "location": _locationController.text,
      "detailed_address": _detailedAddressController.text,
      "desc": _descController.text,
      "building_style_id": selectedBuildingStyleId.value,
      "building_type_id": selectedBuildingTypeId.value,
      "building_owner_id": buildingOwnerId,
    });
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/filming_location/$locationId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
      body: body,
    );
    print("Update response status: ${response.statusCode}");
    print("Update response body: ${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Get.snackbar('Success', 'Location updated successfully');
      Get.back();
    } else {
      Get.snackbar('Error', 'Failed to update location: ${response.body}');
    }
    isLoading.value = false;
  }

  Future<void> _deletePhoto(int photoId) async {
    String token = await _getToken();
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/location/photo/$photoId'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Photo deleted');
      photos.removeWhere((photo) => photo['id'] == photoId);
    } else {
      Get.snackbar('Error', 'Failed to delete photo');
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _detailedAddressController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الموقع'),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomEditableTextFormField(
                    hint: "الموقع",
                    controller: _locationController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال الموقع';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomEditableTextFormField(
                    hint: "تفاصيل العنوان",
                    controller: _detailedAddressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال تفاصيل العنوان';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomEditableTextFormField(
                    hint: "الوصف",
                    controller: _descController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال الوصف';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return DropdownButtonFormField<int>(
                      value: selectedBuildingStyleId.value == 0
                          ? null
                          : selectedBuildingStyleId.value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'نمط البناء',
                      ),
                      items: buildingStyles.map<DropdownMenuItem<int>>((style) {
                        return DropdownMenuItem<int>(
                          value: style['id'],
                          child: Text(style['building_style']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedBuildingStyleId.value = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value == 0) {
                          return 'يرجى اختيار نمط البناء';
                        }
                        return null;
                      },
                    );
                  }),
                  const SizedBox(height: 10),
                  // Dropdown for Building Type
                  Obx(() {
                    return DropdownButtonFormField<int>(
                      value: selectedBuildingTypeId.value == 0
                          ? null
                          : selectedBuildingTypeId.value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'نوع البناء',
                      ),
                      items: buildingTypes.map<DropdownMenuItem<int>>((type) {
                        return DropdownMenuItem<int>(
                          value: type['id'],
                          child: Text(type['building_type']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedBuildingTypeId.value = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value == 0) {
                          return 'يرجى اختيار نوع البناء';
                        }
                        return null;
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                  const Text('الصور:', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (photos.isEmpty) {
                      return const Text('لا توجد صور');
                    }
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: photos.map((photo) {
                        return Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Image.network(
                                "http://10.0.2.2:8000${photo['photo']}",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('حذف الصورة'),
                                        content: const Text(
                                            'هل أنت متأكد من حذف هذه الصورة؟'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('إلغاء'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _deletePhoto(photo['id']);
                                            },
                                            child: const Text('حذف'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  color: Colors.black54,
                                  child: const Icon(Icons.close,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 20),
                  // Update button:
                  ElevatedButton(
                    onPressed: _updateLocation,
                    child: const Text('تحديث الموقع'),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
