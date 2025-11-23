import 'dart:async';

import 'package:flutter/material.dart';
import 'package:models_package/Base/enums.dart';
import 'package:services_package/page_cache_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ui_components_package/mobile_components/Components/list_appbar.dart';

import '../../pages/home/dashboard/dashboard.dart';
import '../../pages/lists/com/person/person_list_page.dart';
import '../../pages/profile/profile.dart';

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  NavButtonTabBarMode _selectedTab = NavButtonTabBarMode.dashboardTabMode;

  late final Widget accountIcon = _paddedIcon('assets/images/account.png');
  late final Widget activeAccountIcon = _paddedIcon(
    'assets/images/activeaccount.png',
  );

  late final Widget defaultIcon = _paddedIcon('assets/images/defaults.png');
  late final Widget activeDefaultIcon = _paddedIcon(
    'assets/images/activedefaults.png',
  );

  late final Widget menuIcon = _paddedIcon('assets/images/menu.png');
  late final Widget activeMenuIcon = _paddedIcon(
    'assets/images/activemenu.png',
  );

  late final Widget openedIcon = _paddedIcon('assets/images/opened.png');
  late final Widget activeOpenedIcon = _paddedIcon(
    'assets/images/activeopened.png',
  );

  late final Widget newIcon = _paddedIcon('assets/images/new.png');
  late final Widget activeNewIcon = _paddedIcon('assets/images/activenew.png');

  final Map<int, Widget> _pageCache = {};
  late final PageCacheManager _cacheManager = PageCacheManager(
    maxAge: const Duration(minutes: 5),
  );

  final Map<int, bool> _showSkeleton = {};
  final Map<int, Timer> _skeletonTimers = {};
  static double size = 40;
  static double topPadding = 10;

  final Map<NavButtonTabBarMode, int> _tabToIndex = {
    NavButtonTabBarMode.menuTabMode: 0,
    NavButtonTabBarMode.newTabMode: 1,
    NavButtonTabBarMode.openedTabMode: 2,
    NavButtonTabBarMode.defaultTabMode: 3,
    NavButtonTabBarMode.profileTabMode: 4,
  };

  final Map<int, NavButtonTabBarMode> _indexToTab = {
    0: NavButtonTabBarMode.menuTabMode,
    1: NavButtonTabBarMode.newTabMode,
    2: NavButtonTabBarMode.openedTabMode,
    3: NavButtonTabBarMode.defaultTabMode,
    4: NavButtonTabBarMode.profileTabMode,
  };

  // لیست tabهای موجود در navigation bar
  final List<NavButtonTabBarMode> _navigationTabs = [
    NavButtonTabBarMode.menuTabMode,
    NavButtonTabBarMode.newTabMode,
    NavButtonTabBarMode.openedTabMode,
    NavButtonTabBarMode.defaultTabMode,
    NavButtonTabBarMode.profileTabMode,
  ];

  Widget _getPage(NavButtonTabBarMode? tab) {
    if (tab == null || tab == NavButtonTabBarMode.dashboardTabMode)
      return const DashboardPage();

    if (_pageCache.containsKey(tab.value)) {
      _showSkeleton[tab.value] = _showSkeleton[tab.value] ?? false;

      return Skeletonizer(
        enabled: _showSkeleton[tab.value] ?? false,
        child: _pageCache[tab.value]!,
      );
    }
    final rawPage = _cacheManager.getOrCreate(tab.value, () {
      switch (tab) {
        case NavButtonTabBarMode.dashboardTabMode:
          return const DashboardPage();
        case NavButtonTabBarMode.menuTabMode:
          // return const MenuPage();
          return const PersonListPage(refreshData: true);
        case NavButtonTabBarMode.profileTabMode:
          return const ProfilePage(refreshData: true);
        default:
          return Center(child: Text("صفحه ${(tab!.value ?? 0)}"));
      }
    });
    _pageCache[tab.value] = rawPage;
    _showSkeleton[tab.value] = true;
    _skeletonTimers[tab.value]?.cancel();
    _skeletonTimers[tab.value] = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        _showSkeleton[tab!.value] = false;
      });
    });
    return Skeletonizer(enabled: true, child: rawPage);
  }

  Widget _paddedIcon(String assetPath) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        package: 'resources_package',
      ),
    );
  }

  void _onItemTapped(NavButtonTabBarMode tab) {
    setState(() {
      _selectedTab = tab;
      _cacheManager.cleanCacheExcept(tab.value);
    });
  }

  PreferredSizeWidget _getAppBar(NavButtonTabBarMode tab) {
    switch (tab) {
      case NavButtonTabBarMode.menuTabMode:
        return ListAppBar(mode: AppBarsMode.erpPersonListMode);
      // return ListAppBar(mode: AppBarsMode.erpApplicationMode);
      case NavButtonTabBarMode.profileTabMode:
        return ListAppBar(mode: AppBarsMode.defaultMode);
      case NavButtonTabBarMode.dashboardTabMode:
      default:
        return ListAppBar(mode: AppBarsMode.defaultMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = NavButtonTabBarMode.values;
    // final currentIndex = tabs.indexOf(_selectedTab);
    final currentIndex = _tabToIndex[_selectedTab] ?? 10;
    return Scaffold(
      appBar: _getAppBar(_selectedTab),
      body: _getPage(_selectedTab),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: currentIndex >= 0 && currentIndex <= 4
                ? currentIndex
                : 0,
            enableFeedback: true,
            type: BottomNavigationBarType.fixed,
            landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
            iconSize: 50,
            elevation: 0,
            onTap: (index) {
              final tab = _indexToTab[index];
              if (tab != null) {
                _onItemTapped(tab);
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: menuIcon,
                activeIcon: activeMenuIcon,
                label: '',
              ),
              BottomNavigationBarItem(
                icon: newIcon,
                activeIcon: activeNewIcon,
                label: '',
              ),
              BottomNavigationBarItem(
                icon: openedIcon,
                activeIcon: activeOpenedIcon,
                label: '',
              ),
              BottomNavigationBarItem(
                icon: defaultIcon,
                activeIcon: activeDefaultIcon,
                label: '',
              ),
              BottomNavigationBarItem(
                icon: accountIcon,
                activeIcon: activeAccountIcon,
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(_selectedTab),
      body: IndexedStack(
        index: _selectedTab.value,
        alignment: Alignment.center,
        children: List.generate(
          5,
          (i) => i == _selectedTab.value
              ? _getPage(i)
              : _pageCache[i] ?? const SizedBox(),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _selectedTab.value,
            enableFeedback: true,
            type: BottomNavigationBarType.fixed,
            landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
            iconSize: 50,
            elevation: 0,
            onTap: (index) => _onItemTapped(NavButtonTabBarMode.values[index]),
            items: [
              BottomNavigationBarItem(
                icon: menuIcon,
                activeIcon: activeMenuIcon,
                label: '',
              ),
              BottomNavigationBarItem(
                icon: newIcon,
                activeIcon: activeNewIcon,
                label: '',
              ),
              BottomNavigationBarItem(
                icon: openedIcon,
                activeIcon: activeOpenedIcon,
                label: '',
              ),
              BottomNavigationBarItem(
                icon: defaultIcon,
                activeIcon: activeDefaultIcon,
                label: '',
              ),
              BottomNavigationBarItem(
                icon: accountIcon,
                activeIcon: activeAccountIcon,
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }*/
}

// abstract class IPageBaseRules {
//   bool get refreshPage;
//   void turnOnRefreshOnLoad();
//   void turnOffRefreshOnLoad();
// }
//
// class MyPage implements IPageBaseRules {
//   bool _refreshPage = true;
//
//   @override
//   bool get refreshPage => _refreshPage;
//
//   @override
//   void turnOnRefreshOnLoad() {
//     _refreshPage = true;
//   }
//
//   @override
//   void turnOffRefreshOnLoad() {
//     _refreshPage = false;
//   }
// }
