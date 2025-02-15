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
        ],
      ),
    );
  }
}
