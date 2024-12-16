import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/director_home_page/director-home_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_text.dart';

class DirectorHomeView extends StatefulWidget {
  @override
  _DirectorHomeViewState createState() => _DirectorHomeViewState();
}

class _DirectorHomeViewState extends State<DirectorHomeView>
    with SingleTickerProviderStateMixin {
  final DirectorHomeController controller = Get.put(DirectorHomeController());
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

//الحركة تبع الصولاة
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Animated position for the image
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: child,
                );
              },
              child: Image.asset('assets/directorhome.webp', width: 300),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCard(),
                  SizedBox(height: 16),
                  _buildCard(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16.0, 8.0, 16.0),
        child: Row(
          children: [
            Container(
              width: 200,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/login.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    text: "عنوان",
                    fontSize: 20,
                    alignment: Alignment.centerRight,
                  ),
                  SizedBox(height: 8),
                  CustomText(
                    text: "تفاصيل",
                    fontSize: 18,
                    alignment: Alignment.centerRight,
                  ),
                  SizedBox(height: 8),
                  CustomText(
                    text: "منتهي",
                    fontSize: 18,
                    alignment: Alignment.centerRight,
                    color: redColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
