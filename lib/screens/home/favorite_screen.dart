// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/favorite_clinic_model.dart';
import 'package:vetplus/providers/favorites_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/clinics/clinic_profile.dart';
import 'package:vetplus/services/clinic_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/sign_utils.dart';
import 'package:vetplus/widgets/common/buttons_bottom_sheet.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  static const route = 'favorites';

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    final List<FavoriteClinicModel> clinics =
        Provider.of<FavoritesProvider>(context).favorites!;

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favorites),
        centerTitle: false,
      ),
      body: SeparatedListView(
        isTablet: isTablet,
        itemCount: clinics.length,
        separator: Padding(
          padding: EdgeInsets.symmetric(vertical: isTablet ? 30 : 20.sp),
          child: const Divider(),
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ClinicProfile.route,
                  arguments: {'id': clinics[index].idClinic});
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    clinics[index].clinicData.image ??
                        'https://preyash2047.github.io/assets/img/no-preview-available.png?h=824917b166935ea4772542bec6e8f636',
                    width: isTablet ? 140 : 100.sp,
                    height: isTablet ? 115 : 75.sp,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: isTablet ? 18 : 10.sp,
                ),
                Expanded(
                  child: Wrap(
                    direction: Axis.vertical,
                    clipBehavior: Clip.antiAlias,
                    spacing: isTablet ? 2 : 2.sp,
                    children: [
                      Text(clinics[index].clinicData.name,
                          style: getSnackBarTitleStyle(isTablet)),
                      Text(
                        clinics[index].clinicData.address,
                        style: getSnackBarBodyStyle(isTablet),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    buildDangerModal(context, clinics[index]);
                  },
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> buildDangerModal(
      BuildContext context, FavoriteClinicModel clinic) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return ButtonsBottomSheet(
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await ClinicService.markClinicAsFavorite(
                    Provider.of<UserProvider>(context, listen: false)
                        .accessToken!,
                    clinic.idClinic,
                    false,
                  ).then((value) async {
                    final accessToken =
                        Provider.of<UserProvider>(context, listen: false)
                            .accessToken!;
                    final favorites = await getFavorites(context, accessToken);
                    Provider.of<FavoritesProvider>(context, listen: false)
                        .setFavorites(favorites.list);
                    Navigator.pop(context);
                  });
                  setState(() {
                    _isLoading = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    : Text(AppLocalizations.of(context)!.removeFromFavorites),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
            ],
          );
        });
      },
    );
  }
}
