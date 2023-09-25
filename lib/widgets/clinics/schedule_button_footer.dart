import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleButtonFooter extends StatelessWidget {
  const ScheduleButtonFooter({
    super.key,
    required this.isTablet,
  });

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 35 : 30.sp,
        horizontal: isTablet ? 29 : 24.sp,
      ),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(AppLocalizations.of(context)!.scheduleAppointment),
      ),
    );
  }
}
