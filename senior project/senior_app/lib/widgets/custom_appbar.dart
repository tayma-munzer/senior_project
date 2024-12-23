import 'package:flutter/material.dart';
import 'package:senior_app/widgets/custom_drawer.dart'; // Import the custom drawer

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          // Open the drawer when the menu icon is pressed
          Scaffold.of(context).openDrawer(); // Opens the drawer
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
