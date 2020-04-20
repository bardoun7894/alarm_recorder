
import 'package:alarm_recorder/notifi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'app_localizations.dart';
//dont remove this unused package ; 
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
 
import 'home_page/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  LocalNotification _local=LocalNotification();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _local.initializing();
  }
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', ''),
      ],
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


