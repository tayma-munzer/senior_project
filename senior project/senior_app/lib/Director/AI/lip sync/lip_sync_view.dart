import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottomappbar_actor.dart';
import 'package:video_player/video_player.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_textfield.dart';
import 'lip_sync_controller.dart';

class LipSyncView extends StatelessWidget {
  final LipSyncController controller = Get.put(LipSyncController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'ادخل النص الذي تريد ان يقال',
              fontSize: 18,
              color: Colors.black,
              alignment: Alignment.centerRight,
            ),
            SizedBox(height: 8),
            CustomTextFormField(
              hint: 'أدخل النص هنا',
              onChanged: (value) => controller.text.value = value,
            ),
            SizedBox(height: 20),
            CustomText(
              text: 'اختر فيديو الشخص الذي تريد منه ان يقول النص',
              fontSize: 18,
              color: Colors.black,
              alignment: Alignment.centerRight,
            ),
            SizedBox(height: 8),
            Center(
              child: IconButton(
                icon: Icon(Icons.video_library, size: 50, color: Colors.blue),
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
            Obx(() {
              return controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : CustomButton(
                      text: 'توليد',
                      onPressed: () => controller.generateLipSync(),
                    );
            }),
            SizedBox(height: 20),
            Obx(() {
              if (controller.generatedVideoUrl.isNotEmpty) {
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
