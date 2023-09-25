import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/buttons_bottom_sheet.dart';

class ClinicProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ClinicProfileAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.surfaceVariant),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
      ),
      actions: [
        IconButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.surfaceVariant),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ButtonsBottomSheet(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(AppLocalizations.of(context)!.addToFavorites),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                  onPressed: () {},
                                  child:
                                      Text(AppLocalizations.of(context)!.done),
                                ),
                              ],
                              title: Text(
                                AppLocalizations.of(context)!.review,
                                style: getBottomSheetTitleStyle(isTablet),
                                textAlign: TextAlign.center,
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    const Divider(),
                                    RatingBar.builder(
                                      allowHalfRating: true,
                                      glow: false,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.symmetric(
                                        horizontal: isTablet ? 8 : 4.sp,
                                        vertical: isTablet ? 20 : 20.sp,
                                      ),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      unratedColor:
                                          Colors.amber.withOpacity(0.2),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    SizedBox(height: isTablet ? 30 : 11.sp),
                                    Text(
                                      AppLocalizations.of(context)!.reviewBody,
                                      style: getBottomSheetBodyStyle(isTablet),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.addReview),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.more_horiz),
        )
      ],
    );
  }
}
