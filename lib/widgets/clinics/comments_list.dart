import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/date_utils.dart';
import 'package:vetplus/widgets/clinics/clinic_comments_info.dart';

import 'comment_owner_widget.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({
    super.key,
    required this.widget,
    required this.appLocalizations,
  });

  final ClinicCommentsInfo widget;
  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.comments.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) =>
          SizedBox(height: widget.isTablet ? 44 : 34.sp),
      itemBuilder: (context, index) {
        final owner = widget.comments[index].owner;
        String timePassed =
            formatTimePassed(widget.comments[index], appLocalizations);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CommentOwnerWidget(
              names: owner.names,
              surnames: owner.surnames,
              image: owner.image,
              appLocalizations: appLocalizations,
              isTablet: widget.isTablet,
              timePassed: timePassed,
            ),
            SizedBox(height: widget.isTablet ? 14 : 6.sp),
            Text(
              widget.comments[index].comment,
              style: getClinicDetailsTextStyle(widget.isTablet)
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ],
        );
      },
    );
  }
}
