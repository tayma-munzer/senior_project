import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewLocationDetailsController extends GetxController {
  final location = <String, dynamic>{}.obs;
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      location.value = args;
    }
    pageController = PageController();
  }

  void nextPage() {
    pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
