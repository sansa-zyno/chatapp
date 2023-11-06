import 'package:chat_app/themes/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = appTheme;
  ThemeData get themeData => _themeData;
  ThemeProvider() {
    _themeData = appTheme;
    notifyListeners();
  }
  void selectLightTheme() {
    _themeData = appTheme;
    notifyListeners();
  }

  void selectDarkTheme() {
    _themeData = darkTheme;
    notifyListeners();
  }
}
