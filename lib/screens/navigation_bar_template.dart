import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/home/home_screen.dart';
import 'package:vetplus/screens/notifications/notifications_screen.dart';
import 'package:vetplus/screens/pets/scan_screen.dart';
import 'package:vetplus/screens/profile/profile_screen.dart';
import 'package:vetplus/screens/search/search_screen.dart';
import 'package:vetplus/screens/sign/welcome_screen.dart';
import 'package:vetplus/widgets/common/custom_dialog.dart';

class NavigationBarTemplate extends StatefulWidget {
  const NavigationBarTemplate({super.key, required this.index});
  static const route = 'navigation-template';
  final int index;

  @override
  State<NavigationBarTemplate> createState() => _NavigationBarTemplateState();
}

class _NavigationBarTemplateState extends State<NavigationBarTemplate> {
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final UserModel? user = Provider.of<UserProvider>(context).user;
    final List<PetModel>? pets = Provider.of<PetsProvider>(context).pets;

    final List<Widget> screens = [
      HomeScreen(user: user, pets: pets),
      const SearchScreen(),
      const ScanScreen(),
      const NotificationsScreen(),
      const ProfileScreen()
    ];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: AppLocalizations.of(context)!.home,
            selectedIcon: const Icon(Icons.home),
          ),
          NavigationDestination(
              icon: const Icon(Icons.search),
              label: AppLocalizations.of(context)!.search),
          _buildScanDestination(isTablet, user),
          NavigationDestination(
            icon: const Icon(Icons.notifications_none_rounded),
            label: AppLocalizations.of(context)!.notifications,
            selectedIcon: const Icon(Icons.notifications),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_2_outlined),
            label: AppLocalizations.of(context)!.profile,
            selectedIcon: const Icon(Icons.person_2),
          ),
        ],
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          if (user == null && index > 1) {
            _buildUnauthorizedDialog(context);
          } else {
            _changeScreenIndex(index);
          }
        },
      ),
      body: screens[_currentIndex],
    );
  }

  Widget _buildScanDestination(bool isTablet, UserModel? user) {
    return GestureDetector(
      onTap: () {
        if (user == null) {
          _buildUnauthorizedDialog(context);
        } else {
          _changeScreenIndex(2);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).colorScheme.primary,
        ),
        padding: EdgeInsets.symmetric(vertical: isTablet ? 10 : 10.sp),
        margin: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 10.sp),
        child: Icon(Icons.qr_code,
            color: Colors.white, size: isTablet ? 34 : 28.sp),
      ),
    );
  }

  void _changeScreenIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<dynamic> _buildUnauthorizedDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: AppLocalizations.of(context)!.accessDeniedTitle,
          body: AppLocalizations.of(context)!.accessDeniedBody,
          color: Theme.of(context).colorScheme.primary,
          icon: Icons.error_outline_outlined,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, WelcomeScreen.route, (route) => false);
              },
              child: Text(AppLocalizations.of(context)!.backToWelcome),
            ),
          ],
        );
      },
    );
  }
}
