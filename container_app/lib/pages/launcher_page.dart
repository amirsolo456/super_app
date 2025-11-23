import 'package:erp_app/main.dart' as erp_app;
import 'package:flutter/material.dart';
import 'package:models_package/Base/language.dart';
import 'login/login_page.dart';


class ShellApp extends StatelessWidget {
  const ShellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super App Launcher',
      home: LauncherPage(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class LauncherPage extends StatelessWidget {
  LauncherPage({super.key});

  final List<_AppOption> options = [
    _AppOption('Login Page', Icons.login, () {
      return LoginPage();
    }),
    _AppOption('ERP App', Icons.business, () {
      return erp_app.buildERPApp(
          Language(id: 0, smallName: 'fa', completeName: 'fa_IR', bigName: 'IR')
      );
    }),
    _AppOption('Other', Icons.widgets, () {
      return const Scaffold(body: Center(child: Text('Other App')));
    }),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super App Launcher')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: options.map((opt) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => opt.builder()),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(opt.icon, size: 50, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(opt.name, style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AppOption {
  final String name;
  final IconData icon;
  final Widget Function() builder;

  _AppOption(this.name, this.icon, this.builder);
}
