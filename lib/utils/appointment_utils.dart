import 'package:flutter/material.dart';

enum AppointmentState { PENDING, FINISHED, ACCEPTED, DENIED }

Color mapStateToColor(AppointmentState state) {
  switch (state) {
    case AppointmentState.PENDING:
      return Colors.blue;
    case AppointmentState.FINISHED:
      return Colors.green;
    case AppointmentState.ACCEPTED:
      return Colors.teal;
    case AppointmentState.DENIED:
      return Colors.red;
    default:
      return Colors.black;
  }
}
