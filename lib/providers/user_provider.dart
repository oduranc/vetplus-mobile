import 'package:flutter/cupertino.dart';
import 'package:vetplus/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  String? _accessToken;

  UserModel? get user => _user;
  String? get accessToken => _accessToken;

  void setUser(UserModel user, String accessToken) {
    _user = user;
    _accessToken = accessToken;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _accessToken = null;
    notifyListeners();
  }
}
