import 'package:flutter/material.dart';

enum AppointmentState {
  PENDING,
  FINISHED,
  IN_PROGRESS,
  DELAYED,
  CANCELLED,
  ACCEPTED,
  DENIED
}

Color mapStateToColor(AppointmentState state) {
  switch (state) {
    case AppointmentState.PENDING:
      return Colors.blue;
    case AppointmentState.FINISHED:
      return Colors.green;
    case AppointmentState.IN_PROGRESS:
      return Colors.lightGreen;
    case AppointmentState.DELAYED:
      return Colors.deepOrange;
    case AppointmentState.CANCELLED:
      return Colors.grey;
    case AppointmentState.ACCEPTED:
      return Colors.teal;
    case AppointmentState.DENIED:
      return Colors.red;
    default:
      return Colors.black;
  }
}
