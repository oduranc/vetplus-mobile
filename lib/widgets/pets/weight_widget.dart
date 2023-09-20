import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/pets/dashboard_card.dart';

class WeightWidget extends StatelessWidget {
  const WeightWidget({
    super.key,
    required this.isTablet,
  });

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: AppLocalizations.of(context)!.weight,
      icon: Icons.fitness_center,
      child: Column(
        children: [
          SleekCircularSlider(
            initialValue: 40,
            min: 0,
            max: 60,
            innerWidget: (value) {
              return Center(
                child: Text(
                  '${value.round()} kg',
                  style: getSnackBarTitleStyle(isTablet)
                      .copyWith(fontFamily: 'Roboto'),
                ),
              );
            },
            appearance: CircularSliderAppearance(
              startAngle: 180,
              angleRange: 180,
              size: isTablet ? 200 : 150,
              customWidths: CustomSliderWidths(
                handlerSize: 0,
                progressBarWidth: isTablet ? 15 : 10,
                shadowWidth: 0,
                trackWidth: isTablet ? 15 : 10,
              ),
              customColors: CustomSliderColors(
                progressBarColor: Theme.of(context).colorScheme.primary,
                trackColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Actual',
                      style: getSnackBarBodyStyle(isTablet).copyWith(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                    ),
                    Text(
                      '40 kg',
                      style: getSnackBarBodyStyle(isTablet).copyWith(
                        fontFamily: 'Roboto',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const VerticalDivider(),
                Column(
                  children: [
                    Text(
                      'Ideal',
                      style: getSnackBarBodyStyle(isTablet).copyWith(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                    ),
                    Text(
                      '60 kg',
                      style: getSnackBarBodyStyle(isTablet).copyWith(
                        fontFamily: 'Roboto',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
