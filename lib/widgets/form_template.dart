import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';

class FormTemplate extends StatefulWidget {
  const FormTemplate({
    super.key,
    required this.children,
    required this.onSubmit,
    required this.buttonText,
  });
  final List<Widget> children;
  final VoidCallback onSubmit;
  final String buttonText;

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
        if (_formKey.currentState!.validate()) {
          setState(() {
            _btnActive = true;
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isTablet ? 99 : 15),
        child: Wrap(
          runSpacing: isTablet ? 46 : 45.sp,
          children: [
            ...widget.children,
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _btnActive ? widget.onSubmit : null,
                  child: Text(widget.buttonText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
