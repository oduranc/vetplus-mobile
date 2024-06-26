import 'package:flutter/material.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField({
    super.key,
    this.controller,
    required this.keyboardType,
    this.isPasswordField = false,
    this.validator,
    required this.labelText,
    this.isBig = false,
    this.textAlignVertical,
    this.contentPadding,
  });

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final String? Function(String?)? validator;
  final String labelText;
  final bool isBig;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsets? contentPadding;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _obscuredText = true;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return TextFormField(
      minLines: widget.isBig ? null : 1,
      maxLines: widget.isBig ? null : 1,
      textAlignVertical: widget.textAlignVertical,
      expands: widget.isBig ? true : false,
      controller: widget.controller,
      style: getFieldTextStyle(isTablet),
      keyboardType: widget.keyboardType,
      obscureText: widget.isPasswordField ? _obscuredText : false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorMaxLines: 3,
        contentPadding: widget.contentPadding,
        suffixIcon: widget.isPasswordField
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscuredText = !_obscuredText;
                  });
                },
                child: Icon(
                  _obscuredText ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
