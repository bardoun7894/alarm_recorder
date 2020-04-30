import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:alarm_recorder/notes/add_note.dart';
import 'package:alarm_recorder/Translate/app_language.dart';
import 'package:alarm_recorder/utils/getlocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'Translate/app_localizations.dart';
//dont remove this unused package ;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home_page/homepage.dart';
import 'package:alarm_recorder/recorder/recorder_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'model/Note.dart'; 

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =   BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =  BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;
String customPayload = "";
Note customNote = Note();
Future<void> main() async {
// needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  //TODO Admob
 // Admob.initialize(getAppId());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var initializationSettingsAndroid = AndroidInitializationSettings('my_smart_note');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
 AppLanguage appLanguage = AppLanguage();
    await appLanguage.fetchLocale();
  runApp(
      MaterialApp(
    navigatorKey: navigatorKey,
    initialRoute: '/',
    routes: {
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/textField': (context) => AddNotes(
            true,
            false,
            false,
            note: customNote,
          ),
      '/recordPlayer': (context) => RecorderPlayer(customPayload),
    },
    home: MyApp(appLanguage: appLanguage),
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
  ));
}
class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
class MyApp extends StatefulWidget {
final AppLanguage appLanguage;
MyApp({this.appLanguage});
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AndroidInitializationSettings initializationSettingsAndroid;
  IOSInitializationSettings initializationSettingsIOS;
  InitializationSettings initializationSettings;
  GetLocation getLocation=GetLocation();
  @override
  void initState() {
    super.initState();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }
  @override
  void dispose() {
    getLocation.disposeLocation();
    super.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
  }
  void _requestIOSPermissions() {
    widget.flutterLocalNotificationsPlugin
         .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    if(getLocation.isListening()){
      getLocation.disposeLocation();
      //TODO check if still work
    //  getLocation.positionStream.pause();
     }

    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      if (receivedNotification.payload.startsWith("{")) {
        Note note = Note.fromRawJson(receivedNotification.payload);
        customNote = note;
        await navigatorKey.currentState
            .popAndPushNamed('/textField', arguments: customNote);
      } else {
        customPayload = receivedNotification.payload;
        await navigatorKey.currentState
            .popAndPushNamed('/recordPlayer', arguments: customPayload);
      }
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      if (payload.startsWith("{")) {
        getLocation.stopLocation();
        Note note = Note.fromRawJson(payload);
        customNote = note;
        await navigatorKey.currentState  .pushNamed('/textField', arguments: customNote);
      } else {
        customPayload = payload;
        print(payload);
        await navigatorKey.currentState
            .pushNamed('/recordPlayer', arguments: customPayload);
          }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider<AppLanguage>(
      child: Consumer<AppLanguage>(
          builder: (context, model, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: model.appLocal,
          supportedLocales: [
            Locale('en','US'),
            Locale('ar',''),  ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
               ],
          home: MyHomePage(),
          );
      }), create:(_) =>  widget.appLanguage,
    );
  }
}
class LocalNotification {
  MyApp myApp = MyApp();

  void showNotificationAfter(int day, int hour, int minute, int id,
      String imgPath, String title, String body, String payload) async {
    await notificationAfter(
        day, hour, minute, id, imgPath, title, body, payload);
  }

  Future<void> notificationAfter(int day, int hour, int minute, int id,  String imgPath, String title, String body, String payload) async {
    String customPayload = "";
    var timeDelayed =  DateTime.now().add(Duration(days: day, hours: hour, minutes: minute));
    var androidNotificationDetails = AndroidNotificationDetails(
        '$id', title, body,
        importance: Importance.Max,
        priority: Priority.High,
        ongoing: true,
        enableVibration: true,
        ticker: 'test ticker',
        playSound: true);
    IOSNotificationDetails iosNotificationDetails =   IOSNotificationDetails(presentSound: true);
    if (payload == "note") {
      Note newNote = Note(id: id, imagePath: imgPath, title: title, description: body);
      customPayload = newNote.toRawJson();
    } else {
      customPayload = payload;
    }

    NotificationDetails notificationDetails =  NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await myApp.flutterLocalNotificationsPlugin.schedule(  id, title, body, timeDelayed, notificationDetails, payload: customPayload);}

  void showNotification(
      int id, String title, String body,imgString,String payload) async {   await notification(id, title, body,imgString,payload);
  }

  Future<void> notification(  int id, String title, String body,String imgPath, String payload) async {

    var androidNotificationDetails = AndroidNotificationDetails(
        '$id', title, body,
        importance: Importance.Max,
        priority: Priority.High,
        ongoing: true,
        enableVibration: true,
        ticker: 'test ticker',
        playSound: true);
    IOSNotificationDetails iosNotificationDetails =  IOSNotificationDetails(presentSound: true);
    NotificationDetails notificationDetails =  NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    Note newNote = Note(id: id, imagePath: imgPath, title: title, description: body);
    payload = newNote.toRawJson();
    await myApp.flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails, payload: payload);
  }
}
String getAppId() {
  //Todo 
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544~1458002511';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544~3347511713';
  }
  return null;
}
