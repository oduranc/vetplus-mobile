import 'package:flutter/material.dart';
import 'package:vetplus/models/favorite_clinic_model.dart';

class FavoritesProvider extends ChangeNotifier {
  List<FavoriteClinicModel>? _favorites;

  List<FavoriteClinicModel>? get favorites => _favorites;

  void setFavorites(List<FavoriteClinicModel> favorites) {
    _favorites = favorites;
    notifyListeners();
  }

  void clearFavorites() {
    _favorites = null;
    notifyListeners();
  }
}
