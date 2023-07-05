import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:timerg/screens/choose_project_screen.dart';

import 'package:timerg/screens/main_screen.dart';
import 'package:timerg/screens/set_project_screen.dart';
import 'package:timerg/screens/timer_screen.dart';

import '../controllers/settings/settings_cubit.dart';
import '../screens/settings_screen.dart';
import '../screens/test_Screen.dart';

class CustomBottomBar extends StatefulWidget {
  static final customBottomBar = GlobalKey<_CustomBottomBarState>();

  const CustomBottomBar({
    final Key? key,
  }) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() => [
        const MainScreen(),
        const TimerScreen(),
        const ChooseProjectScreen(),
        // const MapSample(),
        const SetProjectScreen(),
        const SettingsScreen(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
            icon: const Icon(Icons.aod),
            title: "Report",
            activeColorPrimary: Colors.blueGrey,
            inactiveColorPrimary: Colors.grey,
            inactiveColorSecondary: Colors.purple),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.timer),
          title: "Timer",
          activeColorPrimary: Colors.blueGrey,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.list),
          title: "Projects",
          activeColorPrimary: Colors.blueGrey,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.add_location_alt),
          title: "New",
          activeColorPrimary: Colors.blueGrey,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings),
          title: "Settings",
          activeColorPrimary: Colors.blueGrey,
          inactiveColorPrimary: Colors.grey,
        ),
      ];

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(),
              child: PersistentTabView(
                context,
                onItemSelected: (index) {
                  // context.read<SettingsState>().;
                },
                controller: state.tabController,
                screens: _buildScreens(),
                items: _navBarsItems(),
                resizeToAvoidBottomInset: true,
                padding: const NavBarPadding.all(0),
                navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
                    ? 0.0
                    : kBottomNavigationBarHeight,
                bottomScreenMargin: 0,
                backgroundColor: Colors.white,
                decoration:
                    const NavBarDecoration(colorBehindNavBar: Colors.indigo),
                itemAnimationProperties: const ItemAnimationProperties(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.ease,
                ),
                screenTransitionAnimation: const ScreenTransitionAnimation(
                  animateTabTransition: true,
                ),
                navBarStyle: NavBarStyle.style3,
              ),
            );
          },
        ),
      );
}
