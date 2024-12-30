import 'package:get/get.dart';

class FavoriteLocationController extends GetxController {
  var favoriteLocations = <Map>[].obs;

  void addFavorite(Map location) {
    if (!favoriteLocations.contains(location)) {
      favoriteLocations.add(location);
    }
  }

  void removeFavorite(Map location) {
    favoriteLocations.remove(location);
  }

  bool isFavorite(Map location) {
    return favoriteLocations.contains(location);
  }
}
