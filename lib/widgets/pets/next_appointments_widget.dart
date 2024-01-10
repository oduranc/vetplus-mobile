import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:vetplus/models/appointments_model.dart';
import 'package:vetplus/utils/appointment_utils.dart';
import 'package:vetplus/widgets/pets/dashboard_card.dart';

class NextAppointmentsWidget extends StatelessWidget {
  final bool isTablet;
  final List<AppointmentDetails> appointments;

  const NextAppointmentsWidget({
    super.key,
    required this.isTablet,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: AppLocalizations.of(context)!.upcomingAppointments,
      icon: Icons.event_outlined,
      child: SfCalendar(
        dataSource: _getCalendarDataSource(appointments),
        selectionDecoration: const BoxDecoration(),
        view: CalendarView.month,
        headerStyle: CalendarHeaderStyle(
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: isTablet ? 16 : 12.sp,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            height: 0,
          ),
        ),
        viewHeaderStyle: ViewHeaderStyle(
          dayTextStyle: TextStyle(
            color: Colors.black,
            fontSize: isTablet ? 14 : 10.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            height: 0,
          ),
        ),
        cellBorderColor: Colors.transparent,
        monthViewSettings: MonthViewSettings(
          showTrailingAndLeadingDates: false,
          monthCellStyle: MonthCellStyle(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: isTablet ? 14 : 10.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}

_AppointmentDataSource _getCalendarDataSource(
    List<AppointmentDetails> appointments) {
  List<Appointment> calendarDataSource = <Appointment>[];
  appointments.forEach(
    (e) => calendarDataSource.add(
      Appointment(
        startTime: DateTime.parse(e.startAt),
        endTime: e.endAt != null
            ? DateTime.parse(e.endAt!)
            : DateTime.parse(e.startAt),
        subject: e.pet.name,
        color: mapStateToColor(AppointmentState.values
            .where((element) => element.name == e.state)
            .first),
      ),
    ),
  );

  return _AppointmentDataSource(calendarDataSource);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
