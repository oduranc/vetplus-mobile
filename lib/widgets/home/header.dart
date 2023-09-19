import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/home/favorite_screen.dart';
import 'package:vetplus/screens/navigation_bar_template.dart';
import 'package:vetplus/themes/typography.dart';

class Header extends StatelessWidget {
  final UserModel user;
  const Header({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    return Padding(
      padding: EdgeInsets.only(
          right: isTablet ? 37 : 24.sp, top: isTablet ? 8 : 16.sp),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavigationBarTemplate(index: 4),
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: user.image != null
                  ? NetworkImage(user.image!)
                  : const AssetImage('assets/images/user.png') as ImageProvider,
              backgroundColor: Colors.transparent,
              radius: (isTablet ? 66 : 55.sp) / 2,
            ),
          ),
          SizedBox(width: isTablet ? 6 : 6.sp),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NavigationBarTemplate(index: 4),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.surnames == null
                        ? user.names
                        : '${user.names} ${user.surnames}',
                    style: getButtonBodyStyle(isTablet),
                  ),
                  SizedBox(height: isTablet ? 4 : 4.sp),
                  Text(
                    user.role == 'PET_OWNER'
                        ? AppLocalizations.of(context)!.petOwner
                        : AppLocalizations.of(context)!.veterinarian,
                    style: getSnackBarBodyStyle(isTablet),
                  ),
                ],
              ),
            ),
          ),
          Wrap(
            children: [
              IconButton(
                iconSize: isTablet ? 30 : 25.sp,
                onPressed: () {
                  Navigator.of(context, rootNavigator: false).push(
                      MaterialPageRoute(
                          builder: (context) => FavoriteScreen(),
                          maintainState: false));
                },
                icon: const Icon(Icons.favorite_border_rounded),
              ),
              IconButton(
                iconSize: isTablet ? 30 : 25.sp,
                onPressed: () {},
                icon: const Icon(Icons.receipt_long_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
