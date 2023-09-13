// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/profile_details_dto.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/services/image_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/image_utils.dart';
import 'package:vetplus/utils/user_utils.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/home/add_image_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final UserModel? user = Provider.of<UserProvider>(context).user;
    final items = getItems(context);

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return SkeletonScreen(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.profile)),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: isTablet ? 114 : 43.sp, bottom: isTablet ? 166 : 55.sp),
              child: AddImageButton(
                primaryIcon: Icons.person,
                image: user.image != null ? NetworkImage(user.image!) : null,
                foregroundColor: Colors.black,
                backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                action: () {
                  buildPickImageModal(
                    context,
                    () async {
                      _selectedImage = await pickImage(ImageSource.gallery);
                      setState(() {});
                      await _updateProfileImage(context, user);
                    },
                    () async {
                      _selectedImage = await pickImage(ImageSource.camera);
                      setState(() {});
                      await _updateProfileImage(context, user);
                    },
                  );
                },
                miniIcon: Icons.camera_alt,
                miniButtonStyle: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFE8E8E8)),
                  foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.onInverseSurface),
                ),
                width: (isTablet ? 84 : 70.sp) * 2,
              ),
            ),
            if (!isTablet)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15.sp),
                  child: Text(AppLocalizations.of(context)!.details,
                      style: getSectionTitle(isTablet)),
                ),
              ),
            SeparatedListView(
              isTablet: isTablet,
              itemCount: items.length,
              separator: const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    items[index].action(context);
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    items[index].leadingIcon,
                    color: Theme.of(context).colorScheme.outline,
                    size: isTablet ? 35 : 25.sp,
                  ),
                  title: Text(
                    items[index].name,
                    style: getFieldTextStyle(isTablet),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    size: isTablet ? 35 : 25.sp,
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> _updateProfileImage(BuildContext context, UserModel user) async {
    if (_selectedImage != null) {
      final token =
          Provider.of<UserProvider>(context, listen: false).accessToken!;
      QueryResult imageResult =
          await ImageService.uploadImage(token, _selectedImage!, false);
      Map<String, String?> values = {
        'names': user.names,
        'surnames': user.surnames,
        'document': user.document,
        'address': user.address,
        'telephone_number': user.telephoneNumber,
        'image': imageResult.data!['saveUserImage']['image'],
      };
      await editUserProfile(token, values, context);
    }
  }
}
