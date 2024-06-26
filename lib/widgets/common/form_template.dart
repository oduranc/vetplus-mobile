import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';

class FormTemplate extends StatefulWidget {
  const FormTemplate({
    super.key,
    required this.children,
    required this.onSubmit,
    required this.buttonChild,
    this.formRunSpacing,
    this.padding = const EdgeInsets.symmetric(vertical: 15),
    this.btnActive = false,
  });
  final List<Widget> children;
  final VoidCallback? onSubmit;
  final Widget buttonChild;
  final EdgeInsetsGeometry padding;
  final double? formRunSpacing;
  final bool btnActive;

  @override
  State<FormTemplate> createState() => _FormTemplateState();
}

class _FormTemplateState extends State<FormTemplate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool _btnActive;

  @override
  void initState() {
    _btnActive = widget.btnActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {
        setState(() {
          _btnActive = _formKey.currentState!.validate();
        });
      },
      child: Padding(
        padding: widget.padding,
        child: Wrap(
          runSpacing: widget.formRunSpacing ?? (isTablet ? 46 : 45.sp),
          children: [
            ...widget.children,
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: _btnActive ? widget.onSubmit : null,
                  child: widget.buttonChild,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
