import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/themes/typography.dart';

class CommentOwnerWidget extends StatelessWidget {
  const CommentOwnerWidget({
    super.key,
    required this.names,
    required this.surnames,
    required this.image,
    required this.appLocalizations,
    required this.isTablet,
    required this.timePassed,
  });

  final String names;
  final String? surnames;
  final String? image;
  final AppLocalizations appLocalizations;
  final bool isTablet;
  final String timePassed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: isTablet ? 27.5 : 22.5.sp,
          backgroundColor: Colors.transparent,
          backgroundImage: image != null ? NetworkImage(image!) : null,
          child: image != null ? null : const Icon(Icons.person),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: isTablet ? 15 : 13.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$names ${surnames ?? ''}',
                  style: getClinicDetailsTextStyle(isTablet).copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  timePassed,
                  style: getClinicDetailsTextStyle(isTablet),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
