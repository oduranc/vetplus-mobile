// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/favorites_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/clinics/clinic_profile.dart';
import 'package:vetplus/screens/navigation_bar_template.dart';
import 'package:vetplus/services/clinic_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/sign_utils.dart';
import 'package:vetplus/widgets/common/buttons_bottom_sheet.dart';

class ClinicProfileAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const ClinicProfileAppBar({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<ClinicProfileAppBar> createState() => _ClinicProfileAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ClinicProfileAppBarState extends State<ClinicProfileAppBar> {
  bool _isLoading = false;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    final UserModel? user = Provider.of<UserProvider>(context).user;

    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.surfaceVariant),
        ),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const NavigationBarTemplate(index: 0),
              ),
              (route) => false);
        },
        icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
      ),
      actions: user != null
          ? [
              IconButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.surfaceVariant),
                ),
                onPressed: () async {
                  final accessToken =
                      Provider.of<UserProvider>(context, listen: false)
                          .accessToken!;
                  final currentFavorites =
                      await getFavorites(context, accessToken);
                  for (final element in currentFavorites.list) {
                    if (element.idClinic == widget.id) {
                      _isFavorite = true;
                      break;
                    }
                  }
                  _buildModalBottomSheet(context, accessToken, isTablet);
                },
                icon: const Icon(Icons.more_horiz),
              )
            ]
          : null,
    );
  }

  Future<dynamic> _buildModalBottomSheet(
      BuildContext context, String accessToken, bool isTablet) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return ButtonsBottomSheet(
            children: [
              _buildFavoriteButton(setState, accessToken, context),
              ElevatedButton(
                onPressed: () {
                  showScoreDialog(context, isTablet, accessToken, widget.id);
                },
                child: Text(AppLocalizations.of(context)!.addReview),
              ),
            ],
          );
        });
      },
    );
  }

  Future<dynamic> showScoreDialog(
      BuildContext context, bool isTablet, String accessToken, String id) {
    return showDialog(
      context: context,
      builder: (context) {
        int ratingValue = 1;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await ClinicService.scoreClinic(accessToken, id, ratingValue);
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(ClinicProfile.route));
                  Navigator.pushReplacementNamed(
                    context,
                    ClinicProfile.route,
                    arguments: {'id': id},
                  );
                },
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : Text(AppLocalizations.of(context)!.done),
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
                    glow: false,
                    itemCount: 5,
                    initialRating: 1,
                    itemPadding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 8 : 4.sp,
                      vertical: isTablet ? 20 : 20.sp,
                    ),
                    minRating: 1,
                    maxRating: 5,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    unratedColor: Colors.amber.withOpacity(0.2),
                    onRatingUpdate: (rating) {
                      ratingValue = rating.toInt();
                    },
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
        });
      },
    );
  }

  ElevatedButton _buildFavoriteButton(
      StateSetter setState, String accessToken, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        await _toggleFavorite(accessToken, context);
        setState(() {
          _isLoading = false;
          _isFavorite = !_isFavorite;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _isFavorite
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        side: BorderSide(
          color: _isFavorite
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
        ),
      ),
      child: _isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: _isFavorite
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
            )
          : _isFavorite
              ? Text(AppLocalizations.of(context)!.removeFromFavorites)
              : Text(AppLocalizations.of(context)!.addToFavorites),
    );
  }

  Future<void> _toggleFavorite(String accessToken, BuildContext context) async {
    await ClinicService.markClinicAsFavorite(
      accessToken,
      widget.id,
      !_isFavorite,
    );
    final newFavorites = await getFavorites(context, accessToken);
    Provider.of<FavoritesProvider>(context, listen: false)
        .setFavorites(newFavorites.list);
  }
}
