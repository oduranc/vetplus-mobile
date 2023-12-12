// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/services/user_service.dart';
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

    final editableFields = {
      appLocalizations.nameText: user.names,
      appLocalizations.surnameText: user.surnames ?? appLocalizations.add,
      appLocalizations.idCard: user.document ?? appLocalizations.add,
      appLocalizations.address: user.address ?? appLocalizations.add,
      appLocalizations.telephoneNumber:
          user.telephoneNumber ?? appLocalizations.add,
    };

    final vetEditableFields = {
      appLocalizations.specialty:
          user.vetSpecialty?.specialty ?? appLocalizations.add,
    };

    if (user.role == 'VETERINARIAN') {
      editableFields.addEntries(vetEditableFields.entries);
    }

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
          final field = editableFields.entries.elementAt(index);
          return _buildEditableField(context, field, user, appLocalizations);
        },
      ),
    );
  }

  Widget _buildEditableField(
    BuildContext context,
    MapEntry field,
    UserModel user,
    AppLocalizations appLocalizations,
  ) {
    bool isTablet = Responsive.isTablet(context);

    return ListTile(
      onTap: () {
        _buildEditInfoScreen(context, field, user, appLocalizations);
      },
      contentPadding: EdgeInsets.zero,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.key,
            style: getBottomSheetTitleStyle(isTablet),
          ),
          SizedBox(height: isTablet ? 4 : 4.sp),
          Text(
            field.value ?? appLocalizations.add,
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
  }

  Future<void> _buildEditInfoScreen(
    BuildContext context,
    MapEntry field,
    UserModel user,
    AppLocalizations appLocalizations,
  ) async {
    final fieldName = field.key.toString().toLowerCase();
    TextEditingController editFieldController = TextEditingController();
    editFieldController.text =
        field.value != appLocalizations.add ? field.value : '';

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return LongBottomSheet(
            title: appLocalizations.editInfoScreenTitle(fieldName),
            buttonChild: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white))
                : Text(appLocalizations.update),
            onSubmit: _isLoading
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final updatedValue = editFieldController.text == ''
                        ? null
                        : editFieldController.text;
                    final fieldName = field.key;
                    if (fieldName == appLocalizations.specialty) {
                      await _addSpecialty(
                          fieldName, updatedValue, appLocalizations);
                    } else {
                      await _tryEditField(user, fieldName, updatedValue,
                          context, appLocalizations);
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
            children: [
              CustomFormField(
                controller: editFieldController,
                keyboardType: TextInputType.text,
                labelText: field.key,
              )
            ],
          );
        });
      },
    );
  }

  Future<void> _addSpecialty(
    String fieldName,
    String? specialty,
    AppLocalizations appLocalizations,
  ) async {
    try {
      final accessToken =
          Provider.of<UserProvider>(context, listen: false).accessToken!;

      await UserService.registerSpecialty(accessToken, specialty);

      final user = await getUserProfile(accessToken);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(user, accessToken);

      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: appLocalizations.successEditDialogTitle,
            body: appLocalizations.successEditDialogBody(fieldName),
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.check_circle_outline,
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: appLocalizations.errorEditDialogTitle,
            body: appLocalizations.errorEditDialogBody(fieldName),
            color: Theme.of(context).colorScheme.error,
            icon: Icons.error_outline,
          );
        },
      );
    }
  }

  Future<void> _tryEditField(
    UserModel user,
    String fieldName,
    String? updatedValue,
    BuildContext context,
    AppLocalizations appLocalizations,
  ) async {
    try {
      final accessToken =
          Provider.of<UserProvider>(context, listen: false).accessToken!;

      Map<String, String> targetToKey = {
        appLocalizations.nameText: 'names',
        appLocalizations.surnameText: 'surnames',
        appLocalizations.idCard: 'document',
        appLocalizations.address: 'address',
        appLocalizations.telephoneNumber: 'telephone_number',
      };

      final key = targetToKey[fieldName] ?? fieldName;

      await editUserProfile(accessToken, {key: updatedValue}, context);
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: appLocalizations.successEditDialogTitle,
            body: appLocalizations.successEditDialogBody(fieldName),
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.check_circle_outline,
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: appLocalizations.errorEditDialogTitle,
            body: appLocalizations.errorEditDialogBody(fieldName),
            color: Theme.of(context).colorScheme.error,
            icon: Icons.error_outline,
          );
        },
      );
    }
  }
}
