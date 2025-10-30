import 'package:flutter/material.dart';
import 'homepage.dart';
import './settings.dart';

void main() {
  runApp( MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode=ThemeMode.system;
  void updateThemeMode(ThemeMode newThemeMode){
    setState(() {
      _themeMode=newThemeMode;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'password manager',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Homepage(onThemeChanged: updateThemeMode),
    );
  }
}