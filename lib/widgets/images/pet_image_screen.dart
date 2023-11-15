import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/providers/pets_provider.dart';

class PetImageScreen extends StatelessWidget {
  const PetImageScreen({super.key});
  static const route = 'pet-image-screen';

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final PetModel pet = Provider.of<PetsProvider>(context)
        .pets!
        .where((pet) => pet.id == arguments['id'])
        .first;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Center(
        child: pet.image != null
            ? Image.network(
                pet.image!,
                fit: BoxFit.cover,
                width: double.infinity,
              )
            : Icon(Icons.pets, size: MediaQuery.of(context).size.width),
      ),
    );
  }
}
