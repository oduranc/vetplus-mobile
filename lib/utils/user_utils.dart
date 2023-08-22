import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/services/user_service.dart';

Future<UserModel> getUserProfile(QueryResult<Object?> result) async {
  final res = await UserService.getProfile(
      result.data!['signInWithEmail']['access_token']);
  final profile = res.data!['getMyProfile'];

  UserModel user = UserModel.fromJson(profile);

  return user;
}
