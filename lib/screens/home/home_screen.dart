import 'package:flutter/material.dart';
import 'package:vetplus/widgets/home/header.dart';
import 'package:vetplus/widgets/home/pet_section.dart';
import 'package:vetplus/widgets/home/vet_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      runSpacing: 35,
      children: [
        Header(),
        PetSection(
          itemCount: 2,
          sectionTitle: 'Mis mascotas',
        ),
        VetSection(
          itemCount: 4,
          sectionTitle: 'Mejor valorados',
        ),
        VetSection(
          itemCount: 4,
          sectionTitle: 'Cerca de ti',
        ),
        VetSection(
          itemCount: 4,
          sectionTitle: 'Descubrir',
        ),
        VetSection(
          itemCount: 4,
          sectionTitle: 'Mejor valorados',
        ),
      ],
    );
  }
}
