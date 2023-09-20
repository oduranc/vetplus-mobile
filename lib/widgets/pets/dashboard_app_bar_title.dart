import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';

class DashboardAppBarTitle extends StatelessWidget {
  const DashboardAppBarTitle({
    super.key,
    required this.pet,
    required this.isTablet,
    required this.breedName,
    required this.age,
  });

  final PetModel pet;
  final bool isTablet;
  final String breedName;
  final String age;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: Responsive.isTablet(context) ? 39 : 32.5.sp,
          backgroundColor: const Color(0xFFDCDCDD),
          foregroundColor: const Color(0xFFFBFBFB),
          backgroundImage: pet.image != null ? NetworkImage(pet.image!) : null,
          child: pet.image != null
              ? null
              : Icon(Icons.pets,
                  size: Responsive.isTablet(context) ? 36 : 30.sp),
        ),
        SizedBox(
          width: isTablet ? 20 : 14.sp,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              pet.name,
              style: getBottomSheetTitleStyle(isTablet),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: isTablet ? 6 : 4.sp, bottom: isTablet ? 3 : 1.sp),
              child: Text(
                breedName,
                style: getBottomSheetBodyStyle(isTablet),
              ),
            ),
            Text(
              age,
              style: getBottomSheetBodyStyle(isTablet),
            ),
          ],
        ),
      ],
    );
  }
}
