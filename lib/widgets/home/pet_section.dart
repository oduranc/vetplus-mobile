import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/home/add_pet_button.dart';

class PetSection extends StatelessWidget {
  const PetSection({
    Key? key,
    required this.itemCount,
    required this.sectionTitle,
  }) : super(key: key);

  final int itemCount;
  final String sectionTitle;

  Widget _buildPetsList(context, index) => (index != itemCount - 1)
      ? Column(
          children: [
            CircleAvatar(
              radius: Responsive.isTablet(context) ? 39 : 32.5.sp,
              backgroundColor: Color(0xFFDCDCDD),
              foregroundColor: Color(0xFFFBFBFB),
              child: Icon(Icons.pets,
                  size: Responsive.isTablet(context) ? 36 : 30.sp),
            ),
            Text(
              'Dog',
              style: getCarouselBodyStyle(Responsive.isTablet(context)),
            ),
          ],
        )
      : const AddPetButton();

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          sectionTitle,
          style: getSectionTitle(isTablet),
        ),
        SizedBox(height: isTablet ? 14 : 14.sp),
        SizedBox(
          height: isTablet ? 120 : 90.sp,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 20),
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            itemBuilder: _buildPetsList,
          ),
        ),
      ],
    );
  }
}
