import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/appointments/appointments_history_screen.dart';
import 'package:vetplus/screens/appointments/select_appointments_list.dart';
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

    String role;

    switch (user.role) {
      case 'PET_OWNER':
        role = AppLocalizations.of(context)!.petOwner;
        break;
      case 'VETERINARIAN':
        role = AppLocalizations.of(context)!.veterinarian;
        break;
      case 'CLINIC_OWNER':
        role = AppLocalizations.of(context)!.clinicOwner;
        break;
      default:
        role = AppLocalizations.of(context)!.admin;
    }

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
              backgroundImage:
                  user.image != null ? NetworkImage(user.image!) : null,
              backgroundColor: user.image != null
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.outlineVariant,
              radius: (isTablet ? 66 : 55.sp) / 2,
              child: user.image != null
                  ? null
                  : Icon(
                      Icons.person,
                      size: (isTablet ? 66 : 55.sp) / 2,
                      color: Colors.white,
                    ),
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
                    role,
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
                        builder: (context) => const FavoriteScreen(),
                        maintainState: false),
                  );
                },
                icon: const Icon(Icons.favorite_border_rounded),
              ),
              IconButton(
                iconSize: isTablet ? 30 : 25.sp,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => user.role == 'PET_OWNER'
                          ? AppointmentsHistoryScreen(listRole: user.role)
                          : const SelectAppointmentsList(),
                    ),
                  );
                },
                icon: const Icon(Icons.receipt_long_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
