import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';

class FormTemplate extends StatefulWidget {
  const FormTemplate({
    super.key,
    required this.children,
    required this.onSubmit,
    required this.buttonChild,
    this.padding = const EdgeInsets.symmetric(vertical: 15),
  });
  final List<Widget> children;
  final VoidCallback onSubmit;
  final Widget buttonChild;
  final EdgeInsetsGeometry padding;

  @override
  State<FormTemplate> createState() => _FormTemplateState();
}

class _FormTemplateState extends State<FormTemplate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _btnActive = false;

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
          runSpacing: isTablet ? 46 : 45.sp,
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
