// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/services/user_service.dart';

Future<UserModel> getUserProfile(String accessToken) async {
  final res = await UserService.getProfile(accessToken);
  final profile = res.data!['getMyProfile'];

  UserModel user = UserModel.fromJson(profile);

  return user;
}

Future<void> editUserProfile(String accessToken, Map<String, String?> values,
    BuildContext context) async {
  final res = await UserService.editProfile(accessToken, values);

  final user = await getUserProfile(accessToken);
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  userProvider.setUser(user, accessToken);
}
