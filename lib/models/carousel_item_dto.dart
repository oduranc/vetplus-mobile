import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarouselItemDTO {
  final String image;
  final String title;
  final String description;

  CarouselItemDTO(
      {required this.image, required this.title, required this.description});
}

List<CarouselItemDTO> getItems(BuildContext context) {
  return [
    CarouselItemDTO(
      image: 'assets/images/helper-1.svg',
      title: AppLocalizations.of(context)!.carouselFirstTitle,
      description: AppLocalizations.of(context)!.carouselFirstDescription,
    ),
    CarouselItemDTO(
      image: 'assets/images/helper-2.svg',
      title: AppLocalizations.of(context)!.carouselSecondTitle,
      description: AppLocalizations.of(context)!.carouselSecondDescription,
    ),
    CarouselItemDTO(
      image: 'assets/images/helper-3.svg',
      title: AppLocalizations.of(context)!.carouselThirdTitle,
      description: AppLocalizations.of(context)!.carouselThirdDescription,
    ),
  ];
}
