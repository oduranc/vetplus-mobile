import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vetplus/responsive/responsive_layout.dart';

class CarouselItem extends StatelessWidget {
  const CarouselItem({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);
  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(image, height: isMobile ? null : 337),
        Padding(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 34 : 44),
          child: Text(
            title,
            style: textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          description,
          style: textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
