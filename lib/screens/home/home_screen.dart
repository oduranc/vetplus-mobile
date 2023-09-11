import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/home/header.dart';
import 'package:vetplus/widgets/home/pet_section.dart';
import 'package:vetplus/widgets/home/vet_section.dart';

class HomeScreen extends StatelessWidget {
  final UserModel? user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      providedPadding: EdgeInsets.only(
        left: isTablet ? 37 : 24.sp,
      ),
      body: Wrap(
        runSpacing: 35,
        children: [
          if (user != null) Header(user: user!),
          if (user != null)
            PetSection(
              itemCount: 1,
              sectionTitle: AppLocalizations.of(context)!.myPets,
            ),
          VetSection(
            itemCount: 4,
            sectionTitle: AppLocalizations.of(context)!.topRated,
          ),
          VetSection(
            itemCount: 4,
            sectionTitle: AppLocalizations.of(context)!.closeToYou,
          ),
          VetSection(
            itemCount: 4,
            sectionTitle: AppLocalizations.of(context)!.discover,
          ),
          VetSection(
            itemCount: 4,
            sectionTitle: AppLocalizations.of(context)!.topRated,
          ),
        ],
      ),
    );
  }
}
