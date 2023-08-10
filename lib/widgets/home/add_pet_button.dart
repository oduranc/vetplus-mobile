import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';

class AddPetButton extends StatelessWidget {
  const AddPetButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      child: Stack(
        children: [
          Column(
            children: [
              DottedBorder(
                dashPattern: [5, 5],
                color: Theme.of(context).colorScheme.primary,
                strokeWidth: 4,
                padding: EdgeInsets.zero,
                borderType: BorderType.Circle,
                child: CircleAvatar(
                  radius: Responsive.isTablet(context) ? 39 : 32.5.sp,
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.pets,
                      size: Responsive.isTablet(context) ? 36 : 30.sp),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            heightFactor: 2.7,
            child: SizedBox(
              height: 25,
              width: 25,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 20,
                onPressed: () {},
                icon: Icon(Icons.add),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
