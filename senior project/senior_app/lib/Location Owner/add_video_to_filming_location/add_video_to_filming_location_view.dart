import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Location%20Owner/add_video_to_filming_location/add_video_to_filming_location_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:senior_app/widgets/custom_button.dart';

class AddVideoToFilmingLocationView extends StatefulWidget {
  @override
  _AddVideoToFilmingLocationViewState createState() =>
      _AddVideoToFilmingLocationViewState();
}

class _AddVideoToFilmingLocationViewState
    extends State<AddVideoToFilmingLocationView> {
  late AddVideoToFilmingLocationController controller;
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AddVideoToFilmingLocationController>();
  }

  void _initializeVideoPlayer() {
    if (controller.selectedVideo.value != null) {
      videoController =
          VideoPlayerController.file(controller.selectedVideo.value!)
            ..initialize().then((_) {
              setState(() {});
            });
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة فيديو للموقع التصويري")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "اضف فيديو عن موقعك التصويري",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await controller.pickVideo();
                _initializeVideoPlayer();
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: controller.selectedVideo.value == null
                    ? Center(
                        child: Icon(Icons.video_library,
                            size: 50, color: Colors.grey),
                      )
                    : videoController != null &&
                            videoController!.value.isInitialized
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio:
                                      videoController!.value.aspectRatio,
                                  child: VideoPlayer(videoController!),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        controller.selectedVideo.value = null;
                                        videoController?.dispose();
                                        videoController = null;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(child: CircularProgressIndicator()),
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'التالي',
              onPressed: () =>
                  controller.uploadVideo(1), // Replace 1 with actual locationId
            ),
            SizedBox(height: 10),
            CustomButton(
              text: 'تخطي',
              onPressed: () => Get.offAllNamed('/locationownerHome'),
            ),
          ],
        ),
      ),
    );
  }
}
