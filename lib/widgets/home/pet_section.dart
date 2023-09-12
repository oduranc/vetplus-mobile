import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/pets/first_add_pet_screen.dart';
import 'package:vetplus/services/pet_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/home/add_image_button.dart';

class PetSection extends StatelessWidget {
  const PetSection({
    Key? key,
    required this.sectionTitle,
  }) : super(key: key);

  final String sectionTitle;

  Widget _buildPetsList(BuildContext context, int index, List<PetModel> pets) =>
      (index != pets.length)
          ? Column(
              children: [
                CircleAvatar(
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
                Text(
                  pets[index].name,
                  style: getCarouselBodyStyle(Responsive.isTablet(context)),
                ),
              ],
            )
          : AddImageButton(
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
              width: Responsive.isTablet(context) ? 78 : 65.sp,
            );

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          sectionTitle,
          style: getSectionTitle(isTablet),
        ),
        SizedBox(height: isTablet ? 14 : 14.sp),
        SizedBox(
          height: isTablet ? 120 : 90.sp,
          child: FutureBuilder(
              future: PetService.getMyPets(
                  Provider.of<UserProvider>(context, listen: false)
                      .accessToken!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final petsJson = snapshot.data!;
                  PetList pets = PetList.fromJson(petsJson.data!);
                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(width: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: pets.list.length + 1,
                    itemBuilder: (context, index) {
                      return _buildPetsList(context, index, pets.list);
                    },
                  );
                } else {
                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(width: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return _buildPetsList(context, index, []);
                    },
                  );
                }
              }),
        ),
      ],
    );
  }
}
