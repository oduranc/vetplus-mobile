import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/services/clinic_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/home/vet_list_item.dart';

class VetSection extends StatelessWidget {
  const VetSection({
    Key? key,
    required this.itemCount,
    required this.sectionTitle,
  }) : super(key: key);

  final int itemCount;
  final String sectionTitle;

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(sectionTitle, style: getSectionTitle(isTablet)),
        SizedBox(height: isTablet ? 14 : 14.sp),
        SizedBox(
          height: isTablet ? 200 : 150.sp,
          child: FutureBuilder(
            future: ClinicService.getAllClinic(
                Provider.of<UserProvider>(context, listen: false).accessToken!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      SizedBox(width: isTablet ? 30 : 20.sp),
                  itemCount: 4,
                  padding: EdgeInsets.only(right: isTablet ? 37 : 24.sp),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: isTablet ? 200 : 150.sp,
                        width: isTablet ? 280 : 230.sp,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.serverFailedBody),
                );
              } else if (snapshot.data!.hasException) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.internetConnection),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      SizedBox(width: isTablet ? 30 : 20.sp),
                  itemCount: 4,
                  itemBuilder: (context, index) =>
                      VetListItem(isTablet: isTablet),
                  padding: EdgeInsets.only(right: isTablet ? 37 : 24.sp),
                  scrollDirection: Axis.horizontal,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
