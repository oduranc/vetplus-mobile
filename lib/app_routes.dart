import 'package:flutter/material.dart';
import 'package:vetplus/screens/clinics/clinic_profile.dart';
import 'package:vetplus/screens/home/favorite_screen.dart';
import 'package:vetplus/screens/navigation_bar_template.dart';
import 'package:vetplus/screens/pets/first_add_pet_screen.dart';
import 'package:vetplus/screens/pets/my_pets_screen.dart';
import 'package:vetplus/screens/pets/pet_dashboard.dart';
import 'package:vetplus/screens/pets/pet_profile.dart';
import 'package:vetplus/screens/pets/second_add_pet_screen.dart';
import 'package:vetplus/screens/profile/help_screen.dart';
import 'package:vetplus/screens/profile/personal_information_screen.dart';
import 'package:vetplus/screens/sign/login_screen.dart';
import 'package:vetplus/screens/sign/register_screen.dart';
import 'package:vetplus/screens/sign/welcome_screen.dart';
import 'package:vetplus/widgets/images/image_screen.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return {
    WelcomeScreen.route: (context) => const WelcomeScreen(),
    RegisterScreen.route: (context) => RegisterScreen(),
    LoginScreen.route: (context) => const LoginScreen(),
    NavigationBarTemplate.route: (context) =>
        const NavigationBarTemplate(index: 0),
    FavoriteScreen.route: (context) => const FavoriteScreen(),
    PersonalInformationScreen.route: (context) =>
        const PersonalInformationScreen(),
    FirstAddPetScreen.route: (context) => const FirstAddPetScreen(),
    SecondAddPetScreen.route: (context) => const SecondAddPetScreen(),
    MyPetsScreen.route: (context) => const MyPetsScreen(),
    PetDashboard.route: (context) => const PetDashboard(),
    PetProfile.route: (context) => const PetProfile(),
    ImageScreen.route: (context) => const ImageScreen(),
    ClinicProfile.route: (context) => const ClinicProfile(),
    HelpScreen.route: (context) => const HelpScreen(),
  };
}
