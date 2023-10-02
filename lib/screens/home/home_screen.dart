import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/services/clinic_service.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/home/header.dart';
import 'package:vetplus/widgets/home/pet_section.dart';
import 'package:vetplus/widgets/home/vet_section.dart';

class HomeScreen extends StatelessWidget {
  final UserModel? user;
  final List<PetModel>? pets;
  const HomeScreen({super.key, required this.user, required this.pets});

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      providedPadding: EdgeInsets.only(
        left: isTablet ? 37 : 24.sp,
      ),
      body: FutureBuilder(
          future: ClinicService.getAllClinic(),
          builder: (context, snapshot) {
            return Wrap(
              runSpacing: 35,
              children: [
                if (user != null) Header(user: user!),
                if (user != null)
                  PetSection(
                    sectionTitle: AppLocalizations.of(context)!.myPets,
                    pets: pets,
                    shimmerEffect: _buildPetsShimmerEffect(isTablet),
                  ),
                VetSection(
                  sectionTitle: AppLocalizations.of(context)!.topRated,
                  shimmerEffect: _buildVetsShimmerEffect(isTablet),
                  snapshot: snapshot,
                ),
                VetSection(
                  sectionTitle: AppLocalizations.of(context)!.trending,
                  shimmerEffect: _buildVetsShimmerEffect(isTablet),
                  snapshot: snapshot,
                ),
                VetSection(
                  sectionTitle: AppLocalizations.of(context)!.discover,
                  shimmerEffect: _buildVetsShimmerEffect(isTablet),
                  snapshot: snapshot,
                ),
              ],
            );
          }),
    );
  }

  Shimmer _buildVetsShimmerEffect(bool isTablet) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: isTablet ? 200 : 150.sp,
        width: isTablet ? 280 : 230.sp,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.black),
      ),
    );
  }

  ListView _buildPetsShimmerEffect(bool isTablet) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(width: 20),
      padding: EdgeInsets.only(right: isTablet ? 37 : 24.sp),
      scrollDirection: Axis.horizontal,
      itemCount: pets != null ? pets!.length + 1 : 1,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: CircleAvatar(
            radius: Responsive.isTablet(context) ? 39 : 32.5.sp,
          ),
        );
      },
    );
  }
}
