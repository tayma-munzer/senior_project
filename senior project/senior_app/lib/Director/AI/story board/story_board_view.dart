import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Director/AI/story%20board/story_board_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottomappbar_actor.dart';
import 'package:senior_app/widgets/custom_drawer.dart';
import 'package:senior_app/widgets/custom_text.dart';
import 'package:senior_app/widgets/custom_button.dart';
import 'package:senior_app/widgets/custom_textfield.dart';
import 'package:video_player/video_player.dart';

class StoryBoardView extends StatelessWidget {
  final StoryBoardController controller = Get.put(StoryBoardController());

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
            SizedBox(height: 12),
            Obx(() {
              return controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : CustomButton(
                      text: 'توليد',
                      onPressed: () => controller.generatestoryboard(),
                    );
            }),
            SizedBox(height: 20),
            Obx(() {
              if (controller.showVideo.value) {
                return Column(
                  children: [
                    CustomText(
                      text: 'الفيديو الناتج',
                      fontSize: 18,
                      color: Colors.black,
                      alignment: Alignment.centerRight,
                    ),
                    SizedBox(height: 10),
                    controller.generatedVideoUrl.value.isNotEmpty
                        ? VideoPlayerWidget(controller.generatedVideoUrl.value)
                        : Center(child: Text('لم يتم العثور على فيديو')),
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
  final String videoUrl;

  VideoPlayerWidget(this.videoUrl);

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
        : Center(child: CircularProgressIndicator());
  }
}
