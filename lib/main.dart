import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes/pages/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Map<int, Color> colorCodes = {
      50: const Color.fromRGBO(47, 33, 28, .1),
      100: const Color.fromRGBO(47, 33, 28, .2),
      200: const Color.fromRGBO(47, 33, 28, .3),
      300: const Color.fromRGBO(47, 33, 28, .4),
      400: const Color.fromRGBO(47, 33, 28, .5),
      500: const Color.fromRGBO(47, 33, 28, .6),
      600: const Color.fromRGBO(47, 33, 28, .7),
      700: const Color.fromRGBO(47, 33, 28, .8),
      800: const Color.fromRGBO(47, 33, 28, .9),
      900: const Color.fromRGBO(47, 33, 28, 1),
    };

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF2D2013, colorCodes),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
