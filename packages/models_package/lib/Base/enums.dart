enum AppBarsMode {
  erpPersonListMode(0),
  erpApplicationMode(1),
  defaultMode(2);

  final int value;

  const AppBarsMode(this.value);
}

enum NavButtonTabBarMode {
  menuTabMode(0),
  newTabMode(1),
  openedTabMode(2),
  defaultTabMode(3),
  profileTabMode(4),
  dashboardTabMode(10);

  final int value;

  const NavButtonTabBarMode(this.value);
}
