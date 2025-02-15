import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_app/Director/artwork_details/artwork_details_controller.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'dart:io';

class EditArtworkView extends StatefulWidget {
  EditArtworkView({Key? key}) : super(key: key);

  @override
  _EditArtworkViewState createState() => _EditArtworkViewState();
}

class _EditArtworkViewState extends State<EditArtworkView> {
  final ArtworkDetailsController controller =
      Get.find<ArtworkDetailsController>();

  final TextEditingController titleController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> args = Get.arguments;
    if (args != null) {
      controller.artworkId = args['artworkId'];
      controller.artworkTitle.value = args['artworkTitle'];
    }
    titleController.text = controller.artworkTitle.value;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              CustomText(
                text: "تعديل العمل الفني",
                fontSize: 25,
                color: Colors.black,
                alignment: Alignment.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "عنوان العمل الفني",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _imageFile == null
                      ? Center(
                          child: CustomText(
                            text: "اضغط لاختيار صورة جديدة",
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        )
                      : Image.file(_imageFile!, fit: BoxFit.contain),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: CustomButton(
                  text: "حفظ التعديلات",
                  onPressed: () async {
                    if (titleController.text.isEmpty) {
                      Get.snackbar("خطأ", "الرجاء إدخال عنوان العمل الفني");
                      return;
                    }
                    if (_imageFile == null) {
                      Get.snackbar("خطأ", "الرجاء اختيار صورة جديدة");
                      return;
                    }
                    await controller.updateArtwork(
                      title: titleController.text,
                      poster: _imageFile!,
                    );
                    Get.offNamed('/directorHome');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
