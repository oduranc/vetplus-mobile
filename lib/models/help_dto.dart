import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpDTO {
  final String title;
  final Widget widget;

  HelpDTO({required this.title, required this.widget});
}

List<HelpDTO> getHelpDtoItems(BuildContext context, String title) {
  return [
    HelpDTO(
      title: title,
      widget: Wrap(
        runSpacing: 20.sp,
        children: [
          Image.asset(
            'assets/images/help1-image.png',
          ),
          Text(
            AppLocalizations.of(context)!.helpDtoOne1,
          ),
          Container(),
          Text(AppLocalizations.of(context)!.helpDtoOne2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. '),
              Expanded(child: Text(AppLocalizations.of(context)!.helpDtoOne3)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('2. '),
              Expanded(child: Text(AppLocalizations.of(context)!.helpDtoOne4)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('3. '),
              Expanded(child: Text(AppLocalizations.of(context)!.helpDtoOne5)),
            ],
          ),
        ],
      ),
    ),
    HelpDTO(
      title: title,
      widget: Wrap(
        runSpacing: 20.sp,
        children: [
          Text(
            AppLocalizations.of(context)!.helpDtoTwo1,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. '),
              Expanded(child: Text(AppLocalizations.of(context)!.helpDtoTwo2)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('2. '),
              Expanded(child: Text(AppLocalizations.of(context)!.helpDtoTwo3)),
            ],
          ),
        ],
      ),
    ),
    HelpDTO(
      title: title,
      widget: Wrap(
        runSpacing: 20.sp,
        children: [
          Text(
            AppLocalizations.of(context)!.helpDtoThree1,
          ),
          Text(
            AppLocalizations.of(context)!.helpDtoThree2,
          ),
        ],
      ),
    ),
    HelpDTO(
      title: title,
      widget: Wrap(
        runSpacing: 20.sp,
        children: [
          Text(
            AppLocalizations.of(context)!.helpDtoFour1,
          ),
          Text(
            AppLocalizations.of(context)!.helpDtoFour2,
          ),
        ],
      ),
    ),
    HelpDTO(
      title: title,
      widget: Wrap(
        runSpacing: 20.sp,
        children: [
          Text(
            AppLocalizations.of(context)!.helpDtoFive1,
          ),
          Text(
            AppLocalizations.of(context)!.helpDtoFive2,
          ),
        ],
      ),
    ),
    HelpDTO(
      title: title,
      widget: Wrap(
        runSpacing: 20.sp,
        children: [
          Text(
            AppLocalizations.of(context)!.helpDtoSix1,
          ),
          Text(
            AppLocalizations.of(context)!.helpDtoSix2,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. '),
              Expanded(child: Text(AppLocalizations.of(context)!.helpDtoSix3)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('2. '),
              Expanded(child: Text(AppLocalizations.of(context)!.helpDtoSix4)),
            ],
          ),
          Text(
            AppLocalizations.of(context)!.helpDtoSix5,
          ),
          Text(
            AppLocalizations.of(context)!.helpDtoSix6,
          ),
        ],
      ),
    ),
  ];
}
