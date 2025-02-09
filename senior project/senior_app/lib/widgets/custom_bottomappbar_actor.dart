import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/auth_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: authController.fetchUserProfile(authController.token.value),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator()); // Loading indicator while fetching the profile
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No profile data found'));
        } else {
          final String role = snapshot.data!['role'];
          return BottomNavigationBar(
            items: _getBottomNavItems(role),
            currentIndex: _getCurrentIndex(),
            onTap: (index) => _onItemTapped(index, role),
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
          );
        }
      },
    );
  }

  List<BottomNavigationBarItem> _getBottomNavItems(String role) {
    switch (role) {
      case 'actor':
        return [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ];
      case 'locationowner':
        return [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location),
            label: 'Add Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
      case 'director':
      default:
        return [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Actors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Locations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.art_track),
            label: 'Artwork',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ];
    }
  }

  int _getCurrentIndex() {
    String routeName = Get.currentRoute;
    print('CustomBottomNavBar - Current route: $routeName');

    switch (routeName) {
      case '/directorHome':
      case '/actorHome':
      case '/locationownerhome':
        return 0;
      case '/viewactors':
      case '/actorprofile':
      case '/addlocationowner':
        return 1;
      case '/locationorders':
        return 2;
      case '/artworkDetails':
        return 3;
      case '/locationownerprofile':
        return 3;
      case '/directorpersonalaccount':
        return 4;
      default:
        return 0;
    }
  }

  void _onItemTapped(int index, String role) {
    print('Navigating for role: $role, index: $index');
    switch (role) {
      case 'actor':
        switch (index) {
          case 0:
            Get.offNamed('/actorHome');
            break;
          case 1:
            Get.offNamed('/actorprofile');
            break;
          case 2:
            Get.offNamed('/welcome');
            break;
        }
        break;
      case 'locationowner':
        switch (index) {
          case 0:
            Get.offNamed('/locationownerhome');
            break;
          case 1:
            Get.offNamed('/addlocationowner');
            break;
          case 2:
            Get.offNamed('/locationorders');
            break;
          case 3:
            Get.offNamed('/locationownerprofile');
            break;
        }
        break;
      case 'director':
      default:
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
        break;
    }
  }
}
