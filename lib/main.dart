import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/views/landing.dart';
import 'package:QuizzedGame/locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:QuizzedGame/appLocalizations.dart';

void main() {
  setupServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        fontFamily: 'Airbnb',
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        accentColor: Colors.blue,
        indicatorColor: Colors.blue,
        backgroundColor: Colors.white,
        textTheme: TextTheme(
          // leaderboards
          headline1: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: Colors.white,
          ),
          // profile
          bodyText1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          // playQuiz
          bodyText2: TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ),
      dark: ThemeData(
        fontFamily: 'Airbnb',
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        accentColor: Colors.blue,
        hintColor: Colors.white70,
        indicatorColor: Colors.white,
        backgroundColor: Colors.black,
        textTheme: TextTheme(
          // leaderboards
          headline1: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: Colors.grey[300],
          ),
          //  profile
          bodyText1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
          // playQuiz
          bodyText2: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quiz Game',
        theme: theme,
        darkTheme: darkTheme,
        supportedLocales: [
          Locale('fr', 'FR'),
          Locale('en', 'US'),
          Locale('ar', 'TN'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: Landing(),
      ),
    );
  }
}
