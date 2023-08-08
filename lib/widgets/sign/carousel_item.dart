import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/theme/typography.dart';

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
    final bool isTablet = Responsive.isTablet(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(image,
            height: MediaQuery.of(context).size.height * 0.2612),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.0361),
          child: Text(
            title,
            style: getCarouselTitleStyle(isTablet),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          description,
          style: getCarouselBodyStyle(isTablet),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
