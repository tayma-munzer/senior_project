import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/colors.dart';
import 'package:senior_app/Director/view_actors/view_actors_controller.dart';
import 'package:senior_app/widgets/custom_appbar.dart';
import 'package:senior_app/widgets/custom_bottombar.dart';
import 'package:senior_app/widgets/custom_drawer.dart';

class ViewActorsView extends StatefulWidget {
  @override
  _ViewActorsViewState createState() => _ViewActorsViewState();
}

class _ViewActorsViewState extends State<ViewActorsView>
    with SingleTickerProviderStateMixin {
  final ViewActorsController controller = Get.find();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterDialog();
                  },
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      controller.searchQuery.value = value;
                      controller.fetchActors(search: value);
                    },
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "ابحث",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: Image.asset(
                      "assets/actors.png",
                      width: 150,
                      height: 150,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final actor = controller.filteredActors();
              if (actor.isEmpty) {
                return Center(child: Text("No actors found."));
              }
              return ListView.builder(
                itemCount: actor.length,
                itemBuilder: (context, index) {
                  final actors = actor[index];
                  return _buildActorsCard(actors);
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildActorsCard(Map actors) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/actorsdetails', arguments: actors);
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(
                        "http://10.0.2.2:8000${actors['personal_image']}"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${actors['first_name']} ${actors['last_name']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${actors['country']}: الدولة الحالية",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      actors['availability'] == true ? 'متوفر' : 'غير متوفر',
                      style: TextStyle(
                        fontSize: 14,
                        color: actors['availability'] == true
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    String? selectedMinAge;
    String? selectedMaxAge;
    String? selectedOrdering;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'نوع التمثيل'),
                    onChanged: (value) {
                      controller.actingType.value = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'الدولة الحالية'),
                    onChanged: (value) {
                      controller.livingCountry.value = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'التوافر'),
                    onChanged: (value) {
                      controller.available.value = value;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'الحد الأدنى للعمر'),
                    value: selectedMinAge,
                    items: List.generate(100, (index) => index + 1)
                        .map((age) => DropdownMenuItem(
                              value: age.toString(),
                              child: Text(age.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedMinAge = value;
                      controller.minAge.value = value ?? '';
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'الحد الأقصى للعمر'),
                    value: selectedMaxAge,
                    items: List.generate(100, (index) => index + 1)
                        .map((age) => DropdownMenuItem(
                              value: age.toString(),
                              child: Text(age.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedMaxAge = value;
                      controller.maxAge.value = value ?? '';
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'الترتيب حسب العمر'),
                    value: selectedOrdering,
                    items: [
                      DropdownMenuItem(value: 'age', child: Text('تصاعدي')),
                      DropdownMenuItem(value: '-age', child: Text('تنازلي')),
                    ],
                    onChanged: (value) {
                      selectedOrdering = value;
                      controller.ordering.value = value ?? '';
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                controller.fetchActors(
                  actingType: controller.actingType.value,
                  livingCountry: controller.livingCountry.value,
                  available: controller.available.value,
                  minAge: controller.minAge.value,
                  maxAge: controller.maxAge.value,
                  ordering: controller.ordering.value,
                );
                Navigator.of(context).pop();
              },
              child: Text('تطبيق'),
            ),
          ],
        );
      },
    );
  }
}
