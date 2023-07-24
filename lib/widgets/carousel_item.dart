import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(image),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 34),
              child: Text(title,
                  style: titleCarousel, textAlign: TextAlign.center),
            ),
            Text(
              description,
              style: bodyCarousel.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
