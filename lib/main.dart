import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_unity/screens/ar_screen.dart';

import 'screens/menu_screen.dart';

void main() {
  // TODO - Fix certificate stuff so we dont need this
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Unity Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/ar': (context) => const ArScreen(),
      },
    );
  }
}

// TODO - Fix certificate stuff so we dont need this override
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
