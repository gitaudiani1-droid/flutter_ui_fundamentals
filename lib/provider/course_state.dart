import 'package:flutter/foundation.dart';
//2415051010 - I Gusti Ayu Agung Gita Udiani

class CourseState extends ChangeNotifier {
  final Set<String> favorites = {};
  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    notifyListeners();
  }
  bool isFavorite(String id) {
    return favorites.contains(id);
  }
  int get favoriteCount => favorites.length;
}
