import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vetplus/models/carousel_item_dto.dart';
import 'package:vetplus/widgets/sign/carousel_item.dart';

class WelcomeCarousel extends StatefulWidget {
  const WelcomeCarousel({Key? key}) : super(key: key);

  @override
  State<WelcomeCarousel> createState() => _WelcomeCarouselState();
}

class _WelcomeCarouselState extends State<WelcomeCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        CarouselSlider(
          items: getItems(context).map((item) {
            return Builder(
              builder: (BuildContext context) {
                return CarouselItem(
                  image: item.image,
                  title: item.title,
                  description: item.description,
                );
              },
            );
          }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            enableInfiniteScroll: false,
            viewportFraction: 1,
            aspectRatio: (size.width / size.height) * 1.75,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getItems(context).asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8,
                height: 8,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(_current == entry.key ? 1 : 0.3),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
