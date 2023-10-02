import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.notifications)),
      body: Padding(
        padding: EdgeInsets.only(top: isTablet ? 37 : 24.sp),
        child: SeparatedListView(
          isTablet: isTablet,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: isTablet ? (55 / 2) : (45 / 2).sp,
                foregroundColor: Colors.white,
                backgroundColor: index % 2 == 0
                    ? const Color(0xFF6EC6EB)
                    : Theme.of(context).colorScheme.outlineVariant,
                child: index % 2 == 0
                    ? Icon(Icons.description_outlined, size: isTablet ? 30 : 20)
                    : Icon(Icons.event_outlined, size: isTablet ? 30 : 20),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acceso al historial clínico',
                    style: getBottomSheetTitleStyle(isTablet)
                        .copyWith(height: 0, letterSpacing: 0.16),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: isTablet ? 6 : 2.sp),
                  Text(
                    'Un usuario ha solicitado acceder al historial clínico de su mascota.',
                    style: getBottomSheetBodyStyle(isTablet),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              trailing: IconButton(
                color: Theme.of(context).colorScheme.onInverseSurface,
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
              ),
            );
          },
          itemCount: 4,
          separator: const Divider(),
        ),
      ),
    );
  }
}
