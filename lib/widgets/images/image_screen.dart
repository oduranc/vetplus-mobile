import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  static const route = 'image-screen';

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    final bool isPet = arguments['isPet'] ?? false;
    String? imageUrl = isPet
        ? Provider.of<PetsProvider>(context)
            .pets!
            .where((pet) => pet.id == arguments['id'])
            .first
            .image
        : Provider.of<UserProvider>(context).user!.image;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Center(
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              )
            : Container(
                color: Theme.of(context).colorScheme.outlineVariant,
                child: Icon(
                  isPet ? Icons.pets : Icons.person,
                  size: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
