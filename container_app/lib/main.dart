import 'dart:io';

import 'package:container_app/pages/login/login_bloc.dart';
import 'package:container_app/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:resources_package/l10n/app_localizations.dart';
import 'package:services_package/setup_services.dart';
import 'package:services_package/storage_service.dart';
import 'package:ui_components_package/common_componenets/Buttons/language_button_standalone/language_button_stand_alone.dart';
import 'package:ui_components_package/common_componenets/Buttons/language_button_standalone/language_button_stand_alone_cubit.dart';

final int networkType = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDaFoQ1BufZNuUKKYrVfnoAPjVytggLeJY",
      appId: "1:511210742680:android:a754014ad3e3daefab81ed",
      messagingSenderId: "511210742680",
      projectId: "aryanerp-e996e",
      databaseURL: "https://aryanerp-e996e-default-rtdb.firebaseio.com",
      storageBucket: "aryanerp-e996e.firebasestorage.app",
    ),
  );
  Locale initialLocale = const Locale('fa', 'IR'); // fallback
  setupServices();
  String? token = await FirebaseMessaging.instance.getToken();
  if (token!.isNotEmpty) {
    try {
      final storageService = getIt.get<StorageService>();
      await storageService.setDeviceToken(token);
      final dyn = await storageService
          .getLanguage(); // dynamic: could be String or Locale or null
      initialLocale = Locale(dyn!.languageCode ?? 'fa'); // dyn;
    } catch (e) {
      print(e);
    }
  }
  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;

  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    StorageService storageService = getIt.get<StorageService>();
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageButtonStandAloneCubit>(
          create: (_) => LanguageButtonStandAloneCubit(
            initialLocale: initialLocale,
            storage: storageService,
          ),
        ),
        BlocProvider<LoginBloc>(create: (_) => LoginBloc(networkMode: 0)),
      ],
      child: BlocBuilder<LanguageButtonStandAloneCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: initialLocale,
            supportedLocales: const [Locale('fa', 'IR'), Locale('en', 'US')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              fontFamily: 'IRanSans',
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            ),
            home: const HomeWrapper(),
          );
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Home'),
        actions: const [LanguageButtonStandAlone()],
      ),
      body: const SplashScreenPage(),
    );
  }
}

// MultiProvider(
//   providers: [Provider<LoginBloc>(create: (_) => LoginBloc())],
//   child: MaterialApp(
//     home: BlocProvider(
//       create: (context) => LanguageCubit(),
//       child: MyApp(),
//     ),
//   ),
// ),

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         // BlocProvider(create: (_) => LanguageCubit()),
//         BlocProvider(create: (_) => LoginBloc()),
//       ],
//       child: MaterialApp(
//         theme: ThemeData(
//           fontFamily: 'IRanSans',
//           scaffoldBackgroundColor: Colors.white,
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
//         ),
//         debugShowCheckedModeBanner: false,
//         localizationsDelegates: const [
//           AppLocalizations.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//         ],
//         supportedLocales: [
//           Locale('en'), // English
//           Locale('fa'), // Spanish
//         ],
//         home: const SplashScreenPage(),
//       ),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => LoginBloc()),
//         BlocProvider(create: (_) => LanguageCubit()), // <--- مهم
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         supportedLocales: const [Locale('en', 'US'), Locale('fa', 'IR')],
//         locale: Locale('fa', 'IR'),
//         localizationsDelegates: const [
//           AppLocalizations.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//         ],
//         home: const SplashScreenPage(),
//       ),
//     );
//   }
// }
