import 'package:flutter/material.dart';

class ThemesProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    appBarTheme: const AppBarTheme(
      color: Color(0xFF0F044C),
    ),
    bottomAppBarColor: Colors.black12,
    primaryColor: Colors.black,
    primaryColorDark: Colors.white,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0F044C),
      secondary: Color(0xFF787A91),
      tertiary: Color(0xFF141E61),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFF787A91),
    ),
    fontFamily: 'Nunito',
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(245, 255, 255, 255),
    appBarTheme: const AppBarTheme(color: Color(0xFFFFCAAF)),
    //bottomAppBarColor: Colors.green,
    primaryColor: Colors.white,
    primaryColorDark: Colors.black,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFCAAF),
      secondary: Color(0xFFF1FFC4),
      tertiary: Color(0xFFA7BED3),
    ),
    fontFamily: 'Nunito',
  );
}
