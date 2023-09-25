import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';

class ClinicCommentsInfo extends StatelessWidget {
  const ClinicCommentsInfo({super.key, required this.isTablet});

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.comments,
                style: getClinicTitleStyle(isTablet)),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return LongBottomSheet(
                      title: AppLocalizations.of(context)!.addComment,
                      buttonChild: Text(AppLocalizations.of(context)!.publish),
                      onSubmit: () {},
                      children: [
                        Row(
                          children: [
                            CircleAvatar(radius: isTablet ? 27.5 : 22.5.sp),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: isTablet ? 15 : 13.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'María López',
                                      style: getClinicDetailsTextStyle(isTablet)
                                          .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Hace 2 días',
                                      style:
                                          getClinicDetailsTextStyle(isTablet),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        CustomFormField(
                          keyboardType: TextInputType.multiline,
                          labelText:
                              AppLocalizations.of(context)!.commentExperience,
                          minLines: 6,
                          maxLines: 6,
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.add_comment,
                color: Theme.of(context).colorScheme.outlineVariant,
                size: isTablet ? 30 : 25.sp,
              ),
            )
          ],
        ),
        ListView.separated(
          itemCount: 2,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) =>
              SizedBox(height: isTablet ? 44 : 34.sp),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: isTablet ? 27.5 : 22.5.sp),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: isTablet ? 15 : 13.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'María López',
                              style:
                                  getClinicDetailsTextStyle(isTablet).copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Hace 2 días',
                              style: getClinicDetailsTextStyle(isTablet),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text('⭐ 4.5', style: getClinicDetailsTextStyle(isTablet)),
                  ],
                ),
                SizedBox(height: isTablet ? 14 : 6.sp),
                Text(
                  'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                  style: getClinicDetailsTextStyle(isTablet)
                      .copyWith(color: Colors.black),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
