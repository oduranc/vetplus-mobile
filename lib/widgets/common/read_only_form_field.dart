import 'package:flutter/material.dart';

class ReadOnlyFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final VoidCallback onTap;
  final String? Function(String?)? validator;

  const ReadOnlyFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.onTap,
    this.validator,
  });

  @override
  _ReadOnlyFormFieldState createState() => _ReadOnlyFormFieldState();
}

class _ReadOnlyFormFieldState extends State<ReadOnlyFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      onTap: widget.onTap,
      controller: widget.controller,
      readOnly: true, // Make the text field read-only
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
    );
  }
}
