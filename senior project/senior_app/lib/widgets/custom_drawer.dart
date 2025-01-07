import 'package:flutter/material.dart';
import 'package:senior_app/colors.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 100,
            color: lightblue,
            child: Center(),
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: primaryColor),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('مواقع التصوير المفضلة'),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Item 2'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.red),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Item 3'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
