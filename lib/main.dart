import 'package:flutter/material.dart';
import 'package:movieapp/appUtilites/app_constants.dart';
import 'package:movieapp/screens/home_screen.dart';
import 'api/api_keys.dart';
import 'appUtilites/theme_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MovieData data = MovieData();

  @override


  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: modeChange ? ThemeClass.lightTheme : ThemeClass.darkTheme,
      darkTheme: ThemeClass.darkTheme,
      themeMode: ThemeMode.light,
      home: HomeScreen(),
    );
  }
}
