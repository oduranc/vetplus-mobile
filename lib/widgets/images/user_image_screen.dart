import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/user_provider.dart';

class UserImageScreen extends StatelessWidget {
  const UserImageScreen({super.key});
  static const route = 'user-image-screen';

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).user!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Center(
        child: user.image != null
            ? Image.network(
                user.image!,
                fit: BoxFit.cover,
                width: double.infinity,
              )
            : Icon(Icons.person, size: MediaQuery.of(context).size.width),
      ),
    );
  }
}
