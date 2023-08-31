import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/profile_details_dto.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: isTablet ? 84 : 70.sp,
                backgroundImage: user.image != null
                    ? NetworkImage(user.image!)
                    : const AssetImage('assets/images/user.png') as ImageProvider,
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
}
