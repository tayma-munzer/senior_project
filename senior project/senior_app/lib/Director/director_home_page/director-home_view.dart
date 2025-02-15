import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Director/director_home_page/director-home_controller.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/Director/director_home_page/artwork.dart';
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
      backgroundColor: whiteColor,
      appBar: CustomAppBar(),
      body: Obx(() {
        if (controller.artworks.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchArtworks();
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                    children: controller.artworks.map((artwork) {
                      return _buildCard(artwork);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/addartworkposter');
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildCard(Artwork artwork) {
    return GestureDetector(
      onTap: () {
        controller.setSelectedArtwork(artwork.id);
        Get.toNamed('/artworkDetails', arguments: {
          'artworkId': artwork.id,
          'artworkTitle': artwork.title,
        });
      },
      child: Card(
        elevation: 4,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16.0, 8.0, 16.0),
              child: Row(
                children: [
                  Container(
                    width: 200,
                    height: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "http://10.0.2.2:8000" + artwork.poster),
                        fit: BoxFit.contain,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: CustomText(
                  text: artwork.title,
                  fontSize: 20,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: CustomText(
                  text: artwork.done == 1 ? "منتهي" : "غير مكتمل",
                  fontSize: 22,
                  alignment: Alignment.centerRight,
                  color: artwork.done == 1 ? Colors.green : redColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
