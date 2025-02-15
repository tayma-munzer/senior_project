import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottomappbar_actor.dart';
import 'package:senior_app/widgets/custom_drawer.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';
import 'camera_controller.dart';

class CameraView extends StatelessWidget {
  final CameraController controller = Get.put(CameraController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text
            CustomText(
              text: 'اضف الفيديو المراد تحديد مواقع الكاميرات فيه',
              fontSize: 18,
              color: Colors.black,
              alignment: Alignment.centerRight,
            ),
            SizedBox(height: 8),

            Center(
              child: IconButton(
                icon: Icon(Icons.camera_alt, size: 50, color: Colors.blue),
                onPressed: () => controller.pickVideo(),
              ),
            ),
            SizedBox(height: 20),

            Obx(() {
              if (controller.selectedVideo.value != null) {
                return Column(
                  children: [
                    CustomText(
                      text: 'الفيديو المختار',
                      fontSize: 18,
                      color: Colors.black,
                      alignment: Alignment.centerRight,
                    ),
                    SizedBox(height: 10),
                    VideoPlayerWidget(
                        videoFile: controller.selectedVideo.value!),
                    SizedBox(height: 20),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            }),

            CustomButton(
              text: 'توليد',
              onPressed: () => controller.uploadAndGenerateVideo(),
            ),
            SizedBox(height: 20),

            Obx(() {
              if (controller.generatedVideoUrl.value.isNotEmpty) {
                return Column(
                  children: [
                    CustomText(
                      text: 'الفيديو الناتج',
                      fontSize: 18,
                      color: Colors.black,
                      alignment: Alignment.centerRight,
                    ),
                    SizedBox(height: 10),
                    VideoPlayerWidget(
                        videoUrl: controller.generatedVideoUrl.value),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File? videoFile;
  final String? videoUrl;

  VideoPlayerWidget({this.videoFile, this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.videoFile != null) {
      _controller = VideoPlayerController.file(widget.videoFile!)
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
        });
    } else if (widget.videoUrl != null) {
      _controller = VideoPlayerController.network(widget.videoUrl!)
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
        });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}
