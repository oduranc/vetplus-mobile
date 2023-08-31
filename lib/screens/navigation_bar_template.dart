import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/home/home_screen.dart';
import 'package:vetplus/screens/notifications/notifications_screen.dart';
import 'package:vetplus/screens/pets/scan_screen.dart';
import 'package:vetplus/screens/profile/profile_screen.dart';
import 'package:vetplus/screens/search/search_screen.dart';

class NavigationBarTemplate extends StatefulWidget {
  const NavigationBarTemplate({super.key});
  static const route = 'navigation-template';

  @override
  State<NavigationBarTemplate> createState() => _NavigationBarTemplateState();
}

class _NavigationBarTemplateState extends State<NavigationBarTemplate> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const ScanScreen(),
    const NotificationsScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

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
          _buildScanDestination(isTablet),
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
          _changeScreenIndex(index);
        },
      ),
      body: _screens[_currentIndex],
    );
  }

  Widget _buildScanDestination(bool isTablet) {
    return GestureDetector(
      onTap: () {
        _changeScreenIndex(2);
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
}
