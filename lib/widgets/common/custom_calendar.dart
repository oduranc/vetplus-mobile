import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomCalendar extends StatelessWidget {
  const CustomCalendar({
    super.key,
    required this.now,
    required this.minDate,
    required this.initialDate,
    required this.isTablet,
    required this.onChanged,
  });

  final DateTime now;
  final DateTime minDate;
  final DateTime initialDate;
  final bool isTablet;
  final void Function(dynamic) onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Platform.isIOS
          ? CupertinoDatePicker(
              onDateTimeChanged: onChanged,
              mode: CupertinoDatePickerMode.date,
              maximumDate: now,
              initialDateTime: initialDate,
              minimumDate: minDate,
            )
          : SfDateRangePicker(
              maxDate: now,
              minDate: minDate,
              initialDisplayDate: initialDate,
              initialSelectedDate: initialDate,
              headerHeight: isTablet ? 78 : 68.sp,
              headerStyle: const DateRangePickerHeaderStyle(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              selectionColor: Theme.of(context).colorScheme.primary,
              selectionTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              todayHighlightColor: Theme.of(context).colorScheme.primary,
              monthCellStyle: const DateRangePickerMonthCellStyle(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                todayTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              showNavigationArrow: true,
              onSelectionChanged: onChanged,
            ),
    );
  }
}
