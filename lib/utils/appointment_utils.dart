import 'package:flutter/material.dart';

enum AppointmentState { PENDING, FINISHED, IN_PROGRESS, DELAYED, CANCELLED }

Color mapStateToColor(AppointmentState state) {
  switch (state) {
    case AppointmentState.PENDING:
      return Colors.blue;
    case AppointmentState.FINISHED:
      return Colors.green;
    case AppointmentState.IN_PROGRESS:
      return Colors.orange;
    case AppointmentState.DELAYED:
      return Colors.red;
    case AppointmentState.CANCELLED:
      return Colors.grey;
    default:
      return Colors.black;
  }
}
