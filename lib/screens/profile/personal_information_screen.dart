import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/user_utils.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});
  static const route = 'personal-information';

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    final UserModel user = Provider.of<UserProvider>(context).user!;

    Map<String, String> editableFields = {
      AppLocalizations.of(context)!.nameText: user.names,
      AppLocalizations.of(context)!.surnameText:
          user.surnames ?? AppLocalizations.of(context)!.add,
      AppLocalizations.of(context)!.idCard:
          user.document ?? AppLocalizations.of(context)!.add,
      AppLocalizations.of(context)!.address:
          user.address ?? AppLocalizations.of(context)!.add,
      AppLocalizations.of(context)!.telephoneNumber:
          user.telephoneNumber ?? AppLocalizations.of(context)!.add
    };

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.personalInformation),
        centerTitle: false,
      ),
      body: SeparatedListView(
        isTablet: isTablet,
        itemCount: editableFields.length,
        separator: const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              _buildEditInfoScreen(context, editableFields, index, user);
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

  Future<dynamic> _buildEditInfoScreen(BuildContext context,
      Map<String, String> editableFields, int index, UserModel user) {
    TextEditingController editFieldController = TextEditingController();
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return LongBottomSheet(
          title: AppLocalizations.of(context)!.editInfoScreenTitle(
              editableFields.keys.elementAt(index).toLowerCase()),
          buttonText: AppLocalizations.of(context)!.update,
          onSubmit: () async {
            await _tryEditField(
                user, editableFields, index, editFieldController, context);
          },
          children: [
            CustomFormField(
              controller: editFieldController,
              keyboardType: TextInputType.text,
              labelText: editableFields.keys.elementAt(index),
            )
          ],
        );
      },
    );
  }

  Future<void> _tryEditField(
      UserModel user,
      Map<String, String> editableFields,
      int index,
      TextEditingController editFieldController,
      BuildContext context) async {
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
        'Nombre': 'names',
        'Apellido': 'surnames',
        'Documento de identidad': 'document',
        'Dirección': 'address',
        'Número de teléfono': 'telephone_number',
      };
      if (targetToKey.containsKey(target)) {
        values[targetToKey[target]!] = editFieldController.text;
      }
      print(Provider.of<UserProvider>(context, listen: false).accessToken!);
      final result = await editUserProfile(
          Provider.of<UserProvider>(context, listen: false).accessToken!,
          values);
      print(result);
    } catch (e) {
      print(e);
    }
  }
}
