import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/home/home_screen.dart';
import 'package:vetplus/screens/notifications/notifications_screen.dart';
import 'package:vetplus/screens/profile/profile_screen.dart';
import 'package:vetplus/screens/scan/scan_screen.dart';
import 'package:vetplus/screens/search/search_screen.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

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

    return SkeletonScreen(
      providedPadding: EdgeInsets.only(
        left: isTablet ? 37 : 24.sp,
      ),
      navBar: NavigationBar(
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
            selectedIcon: Icon(Icons.home),
          ),
          const NavigationDestination(
              icon: Icon(Icons.search), label: 'Buscar'),
          _buildScanDestination(isTablet),
          const NavigationDestination(
            icon: Icon(Icons.notifications_none_rounded),
            label: 'Notificaciones',
            selectedIcon: Icon(Icons.notifications),
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            label: 'Perfil',
            selectedIcon: Icon(Icons.person_2),
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
