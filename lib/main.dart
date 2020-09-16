import 'package:flutter/material.dart';
import 'package:QuizzedGame/views/landing.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quizzed Game',
      theme: ThemeData(
        fontFamily: 'Airbnb',
      ),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
        Locale("ar", "TN"),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: Landing(),
    );
  }
}
