import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/services/user_service.dart';

Future<UserModel> getUserProfile(String accessToken) async {
  final res = await UserService.getProfile(accessToken);
  final profile = res.data!['getMyProfile'];

  UserModel user = UserModel.fromJson(profile);

  return user;
}

Future<UserModel> editUserProfile(
    String accessToken, Map<String, String?> values) async {
  final res = await UserService.editProfile(accessToken, values);
  print(res);

  return getUserProfile(accessToken);
}
