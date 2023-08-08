import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final TextTheme textTheme = Theme.of(context).textTheme;

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
            style: textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          description,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
