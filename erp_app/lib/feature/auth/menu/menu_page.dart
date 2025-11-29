import 'package:flutter/material.dart';
import 'package:models_package/Data/Auth/Menu/dto.dart';
import 'package:services_package/Interfaces/fake_data_service.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Lists/Menu/erp_menu.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<Response> _futureMenu;

  @override
  void initState() {
    super.initState();
    _futureMenu = _loadMenu();
  }

  Future<Response> _loadMenu() async {
    return FakeMenuDataService.getFakeMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('منو')),
      body: FutureBuilder<Response>(
        future: _futureMenu,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطا: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('موردی یافت نشد'));
          } else {
            final response = snapshot.data!;
            final menuItems = response.data;

            return VerticalExpansionMenu(
              menuItems: menuItems,
              padding: EdgeInsets.all(10),
              animationDuration: Duration(milliseconds: 300),
              onItemSelected: (item) async {
                return item.subMenus;
              },
            );
          }
        },
      ),
    );
  }
}
