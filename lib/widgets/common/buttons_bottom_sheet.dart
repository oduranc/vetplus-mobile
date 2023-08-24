import 'package:flutter/material.dart';

class ButtonsBottomSheet extends StatelessWidget {
  const ButtonsBottomSheet({
    super.key,
    required this.children,
  });
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 41, right: 24, left: 24),
      child: Wrap(
        runSpacing: 22,
        children: [
          const Divider(
            indent: 100,
            endIndent: 100,
            thickness: 4,
          ),
          ...children,
        ],
      ),
    );
  }
}
