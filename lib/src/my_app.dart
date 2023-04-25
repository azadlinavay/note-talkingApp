import 'package:flutter/material.dart';
import 'package:todo2/src/constants/colors.dart';
import 'package:todo2/src/screens/landingScreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            color: Colors.white,
          ),
          displayLarge: TextStyle(
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
          ),
          displaySmall: TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: backgroundColor,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        useMaterial3: true,
      ),
      home: const LandingScreen(),
    );
  }
}
