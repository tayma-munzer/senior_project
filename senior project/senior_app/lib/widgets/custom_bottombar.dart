import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.grey),
          activeIcon: Icon(Icons.home, color: Colors.blue),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.movie, color: Colors.grey),
          activeIcon: Icon(Icons.movie, color: Colors.blue),
          label: 'Actors',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on, color: Colors.grey),
          activeIcon: Icon(Icons.location_on, color: Colors.blue),
          label: 'Locations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.art_track, color: Colors.grey),
          activeIcon: Icon(Icons.art_track, color: Colors.blue),
          label: 'Artwork',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.grey),
          activeIcon: Icon(Icons.person, color: Colors.blue),
          label: 'Account',
        ),
      ],
      currentIndex: _getCurrentIndex(),
      onTap: (index) {
        _onItemTapped(index);
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    );
  }

  int _getCurrentIndex() {
    String routeName = Get.currentRoute;
    print('Current route: $routeName'); // Add this for debugging

    switch (routeName) {
      case '/directorHome':
        return 0;
      case '/viewactors':
        return 1;
      case '/viewlocations':
        return 2;
      case '/artworkDetails':
        return 3;
      case '/directorpersonalaccount':
        return 4;
      default:
        return 0;
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Get.offNamed('/directorHome');
        break;
      case 1:
        Get.offNamed('/viewactors');
        break;
      case 2:
        Get.offNamed('/viewlocations');
        break;
      case 3:
        Get.offNamed('/artworkDetails');
        break;
      case 4:
        Get.offNamed('/directorpersonalaccount');
        break;
    }
  }
}
