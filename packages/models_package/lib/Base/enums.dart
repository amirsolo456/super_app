enum AppBarsMode {
  erpPersonListMode(0),
  erpNewMode(1),
  erpOpendMode(2),
  erpdefaultMode(3),
  erpprofileMode(4),
  erpdashboardMode(10);


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

enum LoginResultType {
  success,
  error,
  cancelled,
  networkError,
  validationError,
}

enum NetworkMode { live, simulatedSuccess, simulatedError }