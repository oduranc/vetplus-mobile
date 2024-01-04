import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/profile_details_dto.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const route = 'help-screen';

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    final items = getHelpItems(context);

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.help),
        centerTitle: false,
      ),
      body: SeparatedListView(
        isTablet: isTablet,
        itemBuilder: (context, index) {
          return _buildHelpItem(items, index, context, isTablet);
        },
        itemCount: items.length,
        separator: const Divider(),
      ),
    );
  }

  ListTile _buildHelpItem(List<ProfileDetailsDTO> items, int index,
      BuildContext context, bool isTablet) {
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
  }
}
