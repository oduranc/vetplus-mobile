import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/buttons_bottom_sheet.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});
  static const route = 'favorites';

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favorites),
        centerTitle: false,
      ),
      body: SeparatedListView(
        isTablet: isTablet,
        itemCount: 2,
        separator: Padding(
          padding: EdgeInsets.symmetric(vertical: isTablet ? 30 : 20.sp),
          child: const Divider(),
        ),
        itemBuilder: (context, index) {
          return Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://preyash2047.github.io/assets/img/no-preview-available.png?h=824917b166935ea4772542bec6e8f636',
                  width: isTablet ? 140 : 100.sp,
                ),
              ),
              SizedBox(
                width: isTablet ? 18 : 10.sp,
              ),
              Expanded(
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: isTablet ? 2 : 2.sp,
                  children: [
                    Text('Centro veterinario',
                        style: getSnackBarTitleStyle(isTablet)),
                    Text(
                      'La Trinitaria, Santiago',
                      style: getSnackBarBodyStyle(isTablet),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  buildDangerModal(context);
                },
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<dynamic> buildDangerModal(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return ButtonsBottomSheet(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              child: Text(AppLocalizations.of(context)!.removeFromFavorites),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }
}
