import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Director/AI/trailer%20generate/trailergenerate_controller.dart';
import 'package:senior_app/widgets/custom_drawer.dart';
import 'package:video_player/video_player.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottomappbar_actor.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_textfield.dart';

class TrailergeneraterView extends StatelessWidget {
  final TrailergeneraterController controller =
      Get.put(TrailergeneraterController());

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
            CustomText(
              text: 'ادخل رابط فيديو اليوتيوب',
              fontSize: 18,
              color: Colors.black,
              alignment: Alignment.centerRight,
            ),
            SizedBox(height: 8),
            CustomTextFormField(
              hint: 'أدخل الرابط هنا',
              onChanged: (value) => controller.youtubeLink.value = value,
            ),
            SizedBox(height: 20),
            CustomText(
              text: 'مدة الفيديو',
              fontSize: 18,
              color: Colors.black,
              alignment: Alignment.centerRight,
            ),
            SizedBox(height: 8),
            CustomTextFormField(
              hint: 'أدخل المدة هنا',
              onChanged: (value) => controller.videoDuration.value = value,
            ),
            SizedBox(height: 20),
            CustomText(
              text: 'عدد المشاهد',
              fontSize: 18,
              color: Colors.black,
              alignment: Alignment.centerRight,
            ),
            SizedBox(height: 8),
            CustomTextFormField(
              hint: 'أدخل عدد المشاهد هنا',
              onChanged: (value) => controller.numberOfScenes.value = value,
            ),
            SizedBox(height: 20),
            CustomText(
              text: 'نص',
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
            Obx(() {
              return controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : CustomButton(
                      text: 'توليد',
                      onPressed: () => controller.generateTrailer(),
                    );
            }),
            SizedBox(height: 20),
            Obx(() {
              if (controller.showVideo.value) {
                return Center(
                  child: Column(
                    children: [
                      CustomText(
                        text: 'الفيديو الناتج',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: VideoPlayerWidget(
                            videoUrl: controller.videoUrl.value),
                      ),
                    ],
                  ),
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
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
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
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
