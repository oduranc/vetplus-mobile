import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/home/header.dart';
import 'package:vetplus/widgets/home/pet_section.dart';
import 'package:vetplus/widgets/home/vet_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      providedPadding: EdgeInsets.only(
        left: isTablet ? 37 : 24.sp,
      ),
      body: const Wrap(
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
      ),
    );
  }
}
