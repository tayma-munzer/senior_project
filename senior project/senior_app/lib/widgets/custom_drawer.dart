import 'package:flutter/material.dart';
import 'package:senior_app/colors.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header can be customized as per the previous discussion
          Container(
            height: 100, // Set a smaller height for the DrawerHeader
            color: lightblue,
            child: Center(),
          ),

          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // Navigate to '/addlocation' when Item 1 is pressed
              Navigator.pushNamed(context, '/viewlocations');
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              // Handle item 2 tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: Text('Item 3'),
            onTap: () {
              // Handle item 3 tap
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
