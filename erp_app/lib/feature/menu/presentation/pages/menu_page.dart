import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import '../bloc/menu_state.dart';
import '../../domain/entities/menu_entity.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(LoadMenuEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('منو')),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MenuError) {
            return const Center(child: Text('خطا در بارگذاری'));
          }

          if (state is MenuLoaded) {
            // فیلتر منوها بر اساس جستجو
            final filteredMenus = _filterMenus(state.menus, _searchQuery);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'جستجو...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredMenus.length,
                    itemBuilder: (context, index) {
                      return _MenuTile(filteredMenus[index]);
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // تابع بازگشتی برای فیلتر منو و زیرمنوها
  List<MenuEntity> _filterMenus(List<MenuEntity> menus, String query) {
    if (query.isEmpty) return menus;

    List<MenuEntity> result = [];

    for (var menu in menus) {
      // فیلتر زیرمنوها
      final filteredSubMenus = _filterMenus(menu.subMenus, query);

      // اگر خود آیتم یا هر زیرمنو شامل query بود اضافه می‌کنیم
      if (menu.menuDesc.contains(query) || filteredSubMenus.isNotEmpty) {
        result.add(MenuEntity(
          menuId: menu.menuId,
          icon: menu.icon,
          menuDesc: menu.menuDesc,
          iconUrl: menu.iconUrl,
          actionType: menu.actionType,
          menuType: menu.menuType,
          actionId: menu.actionId,
          repoId: menu.repoId,
          subMenus: filteredSubMenus,
        ));
      }
    }

    return result;
  }
}

/// ویجت منوی اصلی با زیرمنوهای تو در تو و آیکون SVG
class _MenuTile extends StatelessWidget {
  final MenuEntity item;
  const _MenuTile(this.item);

  @override
  Widget build(BuildContext context) {
    Widget leadingIcon;
    if (item.icon.isNotEmpty) {
      leadingIcon = SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.string(
          item.icon,
          fit: BoxFit.contain,
          placeholderBuilder: (context) =>
          const CircularProgressIndicator(strokeWidth: 1),
        ),
      );
    } else {
      leadingIcon = const SizedBox(width: 24, height: 24);
    }

    if (item.subMenus.isEmpty) {
      return ListTile(
        leading: leadingIcon,
        title: Text(item.menuDesc),
        onTap: () {
          // Action برای آیتم بدون زیرمنو
          print('Action for ${item.menuDesc}');
        },
      );
    }

    return ExpansionTile(
      leading: leadingIcon,
      title: Text(item.menuDesc),
      children: item.subMenus.map((e) => _MenuTile(e)).toList(),
    );
  }
}
