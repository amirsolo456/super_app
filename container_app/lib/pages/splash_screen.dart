import 'package:flutter/material.dart';
import 'package:ui_components_package/common_componenets/aryan_logo.dart';
import 'login/login_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _translateY;
  late Animation<double> _opacity;

  bool _loaderVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _translateY = Tween<double>(begin: 0, end: -200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Animation + Loader
    Future.delayed(const Duration(milliseconds: 500), () async {
      await _controller.forward();
      if (!mounted) return;
      setState(() => _loaderVisible = true);
    });

    // ناوبری بعد از 2 ثانیه
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, _translateY.value),
                child: Opacity(opacity: _opacity.value, child: AryanLogo()),
              ),
              const SizedBox(height: 40),
              if (_loaderVisible)
                const CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 3,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
