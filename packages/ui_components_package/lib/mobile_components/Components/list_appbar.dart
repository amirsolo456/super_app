import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models_package/Base/enums.dart';
import 'package:resources_package/l10n/app_localizations.dart';
import 'package:ui_components_package/mobile_components/Headers/list_head_actionbar.dart';
import 'list_pagination.dart';

final Widget futuresIcon = Image.asset(
  'assets/images/futures.png',
  package: 'resources_package',
  width: 24,
  height: 24,
);
final Widget moreIcon = Image.asset(
  'assets/images/more.png',
  package: 'resources_package',
  width: 24,
  height: 24,
);

class ListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarsMode mode;

  const ListAppBar({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case AppBarsMode.erpPersonListMode:
        return buildPersonListAppBar(context);

      case AppBarsMode.erpApplicationMode:
        return buildApplicationAppBar(context);

      default:
        return buildDefaultAppBar(context);
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

AppBar buildPersonListAppBar(BuildContext context) {
  return AppBar(
    title: Text(
      textAlign: TextAlign.start,
      AppLocalizations.of(context)!.personList,
      style: TextStyle(color: Colors.black),
    ),
    centerTitle: true,
    actions: [
      IconButton(
        onPressed: () {},
        icon: futuresIcon,
        highlightColor: Colors.black.withOpacity(0.05),
      ),
      IconButton(
        onPressed: () {},
        icon: moreIcon,
        highlightColor: Colors.black.withOpacity(0.05),
      ),
    ],
    backgroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
    toolbarHeight: 70,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [ListPagination(), ButtonPanel()],
        ),
      ),
    ),
  );
}

AppBar buildApplicationAppBar(BuildContext context) {
  return AppBar(
    scrolledUnderElevation: 0.0,
    elevation: 0.0,
    backgroundColor: Colors.white,
    primary: true,
    title: Text(
      AppLocalizations.of(context)!.profileTitle,
      style: const TextStyle(color: Color(0xFF585858)),
    ),
    centerTitle: false,
  );
}

AppBar buildDefaultAppBar(BuildContext context) {
  return AppBar(
    title: Text("صفحه ${1}"),
    elevation: 0.0,
    primary: true,
    backgroundColor: Colors.white,
    scrolledUnderElevation: 0.0,
  );
}
