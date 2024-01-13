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
import 'package:vetplus/widgets/clinics/comment_owner_widget.dart';
import 'package:vetplus/widgets/clinics/comments_list.dart';
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
                  _buildCreateCommentBottomSheet(
                      context, appLocalizations, user);
                },
                icon: Icon(
                  Icons.add_comment,
                  color: Theme.of(context).colorScheme.outlineVariant,
                  size: widget.isTablet ? 30 : 25.sp,
                ),
              )
          ],
        ),
        CommentsList(widget: widget, appLocalizations: appLocalizations)
      ],
    );
  }

  Future<dynamic> _buildCreateCommentBottomSheet(
      BuildContext context, AppLocalizations appLocalizations, UserModel user) {
    return showModalBottomSheet(
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
                    child: CircularProgressIndicator(color: Colors.white))
                : Text(appLocalizations.publish),
            onSubmit:
                _isLoading ? null : () => _submitComment(context, setState),
            children: [
              CommentOwnerWidget(
                names: user.names,
                surnames: user.surnames,
                image: user.image,
                points: null,
                appLocalizations: appLocalizations,
                isTablet: widget.isTablet,
                timePassed: appLocalizations.justNow,
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
                  textAlignVertical: TextAlignVertical.top,
                  contentPadding: EdgeInsets.all(12.sp),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _submitComment(
      BuildContext context, StateSetter setState) async {
    setState(() {
      _isLoading = true;
    });
    final accessToken =
        Provider.of<UserProvider>(context, listen: false).accessToken!;
    final commentText = commentsController.text;

    try {
      await ClinicService.registerComment(accessToken, widget.id, commentText);
      Navigator.of(context).popUntil(ModalRoute.withName(ClinicProfile.route));
      Navigator.pushReplacementNamed(context, ClinicProfile.route,
          arguments: {'id': widget.id});
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
