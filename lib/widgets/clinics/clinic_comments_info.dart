// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/comment_model.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/screens/clinics/clinic_profile.dart';
import 'package:vetplus/services/clinic_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/validation_utils.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';

class ClinicCommentsInfo extends StatefulWidget {
  const ClinicCommentsInfo(
      {super.key,
      required this.isTablet,
      required this.comments,
      required this.id});

  final bool isTablet;
  final List<CommentModel> comments;
  final String id;

  @override
  State<ClinicCommentsInfo> createState() => _ClinicCommentsInfoState();
}

class _ClinicCommentsInfoState extends State<ClinicCommentsInfo> {
  final commentsController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final UserModel? user = Provider.of<UserProvider>(context).user;

    return Wrap(
      runSpacing: widget.isTablet ? 33 : 29.sp,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(appLocalizations.comments,
                style: getClinicTitleStyle(widget.isTablet)),
            if (user != null)
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return LongBottomSheet(
                          title: appLocalizations.addComment,
                          buttonChild: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : Text(appLocalizations.publish),
                          onSubmit: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            final accessToken = Provider.of<UserProvider>(
                                    context,
                                    listen: false)
                                .accessToken!;
                            await ClinicService.registerComment(accessToken,
                                widget.id, commentsController.text);
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.of(context).popUntil(
                                ModalRoute.withName(ClinicProfile.route));
                            Navigator.pushReplacementNamed(
                              context,
                              ClinicProfile.route,
                              arguments: {'id': widget.id},
                            );
                          },
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: widget.isTablet ? 27.5 : 22.5.sp,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: user.image != null
                                      ? NetworkImage(user.image!)
                                      : null,
                                  child: user.image != null
                                      ? null
                                      : const Icon(Icons.person),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: widget.isTablet ? 15 : 13.sp),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${user.names} ${user.surnames ?? ''}',
                                          style: getClinicDetailsTextStyle(
                                                  widget.isTablet)
                                              .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          appLocalizations.justNow,
                                          style: getClinicDetailsTextStyle(
                                              widget.isTablet),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 200,
                              child: CustomFormField(
                                validator: (value) {
                                  return validateComment(value, context);
                                },
                                controller: commentsController,
                                keyboardType: TextInputType.multiline,
                                labelText: appLocalizations.commentExperience,
                                isBig: true,
                              ),
                            ),
                          ],
                        );
                      });
                    },
                  );
                },
                icon: Icon(
                  Icons.add_comment,
                  color: Theme.of(context).colorScheme.outlineVariant,
                  size: widget.isTablet ? 30 : 25.sp,
                ),
              )
          ],
        ),
        ListView.separated(
          itemCount: widget.comments.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) =>
              SizedBox(height: widget.isTablet ? 44 : 34.sp),
          itemBuilder: (context, index) {
            final owner = widget.comments[index].owner;
            final time = DateTime.now()
                .difference(DateTime.parse(widget.comments[index].updatedAt));
            String timePassed;
            if (time.inSeconds < 60) {
              timePassed = '${time.inSeconds} ${appLocalizations.seconds}';
            } else if (time.inMinutes < 60) {
              timePassed = '${time.inMinutes} ${appLocalizations.minutes}';
            } else if (time.inHours < 24) {
              timePassed = '${time.inHours} ${appLocalizations.hours}';
            } else if (time.inDays < 30) {
              timePassed = '${time.inDays} ${appLocalizations.days}';
            } else if (time.inDays < 365) {
              timePassed =
                  '${(time.inDays / 30).floor()} ${appLocalizations.months}';
            } else {
              timePassed =
                  '${(time.inDays / 365).floor()} ${appLocalizations.years}';
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: widget.isTablet ? 27.5 : 22.5.sp,
                      backgroundImage: owner.image != null
                          ? NetworkImage(owner.image!)
                          : null,
                      backgroundColor: Colors.transparent,
                      child: owner.image == null
                          ? Icon(
                              Icons.person,
                              size: widget.isTablet ? 55 : 45.sp,
                            )
                          : null,
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: widget.isTablet ? 15 : 13.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${owner.names} ${owner.surnames}',
                              style: getClinicDetailsTextStyle(widget.isTablet)
                                  .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              appLocalizations.ago(timePassed),
                              style: getClinicDetailsTextStyle(widget.isTablet),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
        )
      ],
    );
  }
}
