import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/breed_model.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/pets/first_add_pet_screen.dart';
import 'package:vetplus/screens/pets/pet_dashboard.dart';
import 'package:vetplus/services/breed_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/pet_utils.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/home/add_image_button.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});
  static const route = 'my-pets-screen';

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    final List<PetModel>? pets = Provider.of<PetsProvider>(context).pets;

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myPets),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: isTablet ? 37 : 24.sp),
            child: AddImageButton(
              primaryIcon: Icons.pets,
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.white,
              hasBorder: true,
              action: () {
                Navigator.pushNamed(context, FirstAddPetScreen.route);
              },
              miniIcon: Icons.add,
              miniButtonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              width: Responsive.isTablet(context) ? 60 : 40.sp,
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: FutureBuilder(
          future: BreedService.getAllBreeds(
              Provider.of<UserProvider>(context, listen: false).accessToken!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(AppLocalizations.of(context)!.serverFailedBody),
              );
            } else {
              final breedsJson = snapshot.data!;
              BreedList breeds = BreedList.fromJson(breedsJson.data!);
              return SeparatedListView(
                isTablet: isTablet,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PetDashboard.route,
                        arguments: {
                          'pet': pets[index],
                          'age': getFormattedAge(pets, index, context),
                          'breedName': getBreedName(breeds, pets, index),
                        },
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: Responsive.isTablet(context) ? 39 : 32.5.sp,
                      backgroundColor: Color(0xFFDCDCDD),
                      foregroundColor: Color(0xFFFBFBFB),
                      backgroundImage: pets[index].image != null
                          ? NetworkImage(pets[index].image!)
                          : null,
                      child: pets[index].image != null
                          ? null
                          : Icon(Icons.pets,
                              size: Responsive.isTablet(context) ? 36 : 30.sp),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pets[index].name,
                          style: getSnackBarTitleStyle(isTablet),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: isTablet ? 6 : 4.sp,
                              bottom: isTablet ? 3 : 1.sp),
                          child: Text(
                            getBreedName(breeds, pets, index),
                            style: getSnackBarBodyStyle(isTablet),
                          ),
                        ),
                        Text(
                          getFormattedAge(pets, index, context),
                          style: getSnackBarBodyStyle(isTablet),
                        )
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      size: isTablet ? 35 : 25.sp,
                    ),
                  );
                },
                itemCount: pets!.length,
                separator: const Divider(),
              );
            }
          }),
    );
  }
}
