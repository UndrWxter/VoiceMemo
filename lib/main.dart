import 'package:flutter/material.dart';
import 'package:notes/services/sharedPref.dart';
import 'package:notes/screens/home.dart'; // Исправлен импорт
import 'data/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeData theme;
  
  @override
  void initState() {
    super.initState();
    theme = appThemeLight; // установка начального значения
    updateThemeFromSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: HomePage( // Исправлено название виджета
        changeTheme: setTheme,
      ),
    );
  }

  void setTheme(Brightness brightness) {
    setState(() {
      theme = brightness == Brightness.dark ? appThemeDark : appThemeLight;
    });
  }

  Future<void> updateThemeFromSharedPref() async {
    final String themeText = await getThemeFromSharedPref();
    setTheme(themeText == 'light' ? Brightness.light : Brightness.dark);
  }
}
