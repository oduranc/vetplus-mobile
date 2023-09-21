import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/user_utils.dart';
import 'package:vetplus/widgets/common/custom_dialog.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});
  static const route = 'personal-information';

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    final UserModel user = Provider.of<UserProvider>(context).user!;
    final appLocalizations = AppLocalizations.of(context)!;

    Map<String, String> editableFields = {
      appLocalizations.nameText: user.names,
      appLocalizations.surnameText: user.surnames ?? appLocalizations.add,
      appLocalizations.idCard: user.document ?? appLocalizations.add,
      appLocalizations.address: user.address ?? appLocalizations.add,
      appLocalizations.telephoneNumber:
          user.telephoneNumber ?? appLocalizations.add
    };

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        title: Text(appLocalizations.personalInformation),
        centerTitle: false,
      ),
      body: SeparatedListView(
        isTablet: isTablet,
        itemCount: editableFields.length,
        separator: const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              _buildEditInfoScreen(
                  context, editableFields, index, user, appLocalizations);
            },
            contentPadding: EdgeInsets.zero,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  editableFields.keys.elementAt(index),
                  style: getBottomSheetTitleStyle(isTablet),
                ),
                SizedBox(height: isTablet ? 4 : 4.sp),
                Text(
                  editableFields.values.elementAt(index),
                  style: getCarouselBodyStyle(isTablet)
                      .copyWith(color: Theme.of(context).colorScheme.outline),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.onInverseSurface,
              size: isTablet ? 35 : 25.sp,
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> _buildEditInfoScreen(
      BuildContext context,
      Map<String, String> editableFields,
      int index,
      UserModel user,
      AppLocalizations appLocalizations) {
    TextEditingController editFieldController = TextEditingController();
    editFieldController.text =
        editableFields.values.elementAt(index) == appLocalizations.add
            ? ''
            : editableFields.values.elementAt(index);
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return LongBottomSheet(
            title: appLocalizations.editInfoScreenTitle(
                editableFields.keys.elementAt(index).toLowerCase()),
            buttonChild: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(appLocalizations.update),
            onSubmit: () async {
              setState(() {
                _isLoading = true;
              });
              await _tryEditField(user, editableFields, index,
                  editFieldController, context, appLocalizations);
              setState(() {
                _isLoading = false;
              });
            },
            children: [
              CustomFormField(
                controller: editFieldController,
                keyboardType: TextInputType.text,
                labelText: editableFields.keys.elementAt(index),
              )
            ],
          );
        });
      },
    );
  }

  Future<void> _tryEditField(
      UserModel user,
      Map<String, String> editableFields,
      int index,
      TextEditingController editFieldController,
      BuildContext context,
      AppLocalizations appLocalizations) async {
    try {
      Map<String, String?> values = {
        'names': user.names,
        'surnames': user.surnames,
        'document': user.document,
        'address': user.address,
        'telephone_number': user.telephoneNumber,
        'image': user.image,
      };
      final target = editableFields.keys.elementAt(index);
      Map<String, String> targetToKey = {
        appLocalizations.nameText: 'names',
        appLocalizations.surnameText: 'surnames',
        appLocalizations.idCard: 'document',
        appLocalizations.address: 'address',
        appLocalizations.telephoneNumber: 'telephone_number',
      };
      if (targetToKey.containsKey(target)) {
        values[targetToKey[target]!] = editFieldController.text;
      }
      await editUserProfile(
          Provider.of<UserProvider>(context, listen: false).accessToken!,
          values,
          context);
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
                title: appLocalizations.successEditDialogTitle,
                body: appLocalizations.successEditDialogBody(
                    editableFields.keys.elementAt(index)),
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.check_circle_outline);
          },
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: appLocalizations.errorEditDialogTitle,
            body: appLocalizations
                .errorEditDialogBody(editableFields.keys.elementAt(index)),
            color: Theme.of(context).colorScheme.error,
            icon: Icons.error_outline,
          );
        },
      );
    }
  }
}
