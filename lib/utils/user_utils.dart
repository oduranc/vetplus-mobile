import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/services/user_service.dart';

Future<UserModel> getUserProfile(String accessToken) async {
  final res = await UserService.getProfile(accessToken);
  print(res);
  final profile = res.data!['getMyProfile'];

  UserModel user = UserModel.fromJson(profile);

  return user;
}
