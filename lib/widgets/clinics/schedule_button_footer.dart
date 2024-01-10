import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/clinic_model.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/screens/appointments/schedule_appointment_screen.dart';

class ScheduleButtonFooter extends StatelessWidget {
  const ScheduleButtonFooter({
    super.key,
    required this.isTablet,
    required this.clinic,
    required this.user,
  });

  final bool isTablet;
  final ClinicModel clinic;
  final UserModel user;

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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleAppointmentScreen(
                clinic: clinic,
                user: user,
              ),
            ),
          );
        },
        child: Text(AppLocalizations.of(context)!.scheduleAppointment),
      ),
    );
  }
}
