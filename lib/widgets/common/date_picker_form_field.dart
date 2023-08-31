import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final DateTime initialDate;

  const DatePickerFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.initialDate,
  });

  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text = DateFormat().locale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        _selectDate(context);
      },
      controller: widget.controller,
      readOnly: true, // Make the text field read-only
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
    );
  }
}
