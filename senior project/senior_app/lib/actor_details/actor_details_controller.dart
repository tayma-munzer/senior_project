// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ActorDetailsController extends GetxController {
//   final actor = <String, dynamic>{}.obs;
//   late PageController pageController;

//   @override
//   void onInit() {
//     super.onInit();

//     final args = Get.arguments;
//     if (args is Map<String, dynamic>) {
//       actor.value = args;
//     } else {
//       print("Error: Arguments are null or invalid");
//       actor.value = {
//         'name': 'Unknown',
//         'images': ['assets/login.png', 'assets/signup.png'],
//         'age': 'Unknown',
//         'acting_type': 'Unknown',
//       };
//     }
//     pageController = PageController();
//   }

//   void nextPage() {
//     pageController.nextPage(
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   void previousPage() {
//     pageController.previousPage(
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void onClose() {
//     pageController.dispose();
//     super.onClose();
//   }
// }
