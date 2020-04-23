
import 'package:alarm_recorder/notes/textFieldCustom.dart';
import 'package:alarm_recorder/notifi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'app_localizations.dart';
//dont remove this unused package ; 
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home_page/homepage.dart';
import 'package:alarm_recorder/recorder/recorder_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notes/note_list.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;


Future<void> main()  async{
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
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

  runApp(MaterialApp(
    home: MyApp(),
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  final navigatorKey = GlobalKey<NavigatorState>();

  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  initializing();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
  }


  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RecorderPlayer(receivedNotification.payload),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      print(payload);
      await showDialog(context: context,builder: (BuildContext context){
        return AlertDialog(
          title: Text(""),
          content:Text('Test'),
          actions: <Widget>[
            MaterialButton(
              child: Text("jsdjnjkds"),
                onPressed: ()async{
              await Navigator.of(context).push( MaterialPageRoute(builder: (context) => NoteList()), );
            })

          ],

        );
      });

     //
    });

  }


//  void initializing() async{
//
//    androidInitializationSettings=AndroidInitializationSettings('app_icon');
//    iosInitializationSettings=IOSInitializationSettings(onDidReceiveLocalNotification:onDidReceiveLocalNotification );
//    initializationSettings=InitializationSettings(androidInitializationSettings,iosInitializationSettings);
//    await widget.flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
//  }
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/noteList': (context) => NoteList(),
         },
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


//    onSelectNotification(String payload) async {
//    if (payload != null) {  debugPrint('notification payload: ' + payload);  }
//    showDialog(
//      context: context,
//      builder: (BuildContext ctx) => new CupertinoAlertDialog(
//        title: new Text("title"),
//        content: new Text("body"),
//        actions: [
//          CupertinoDialogAction(
//            isDefaultAction: true,
//            child: new Text('Ok'),
//            onPressed: () async {
////              Navigator.of(context, rootNavigator: true).pop();
////              await Navigator.push(
////                context,
////                new MaterialPageRoute(
////                  builder: (context) => new MyTextFieldCustom(),
////                ),
////              );
//            },
//          )
//        ],
//      ),
//    );
//
//  }
//
//
//  Future onDidReceiveLocalNotification(int id,String title,String body,String payload) async {
//    // display a dialog with the notification details, tap ok to go to another page
//    showDialog(
//      context: context,
//      builder: (BuildContext ctx) => new CupertinoAlertDialog(
//        title: new Text(title),
//        content: new Text(body),
//        actions: [
//          CupertinoDialogAction(
//            isDefaultAction: true,
//            child: new Text('Ok'),
//            onPressed: () async {
//              Navigator.of(context, rootNavigator: true).pop();
//              await Navigator.push(
//                context,
//                new MaterialPageRoute(
//                  builder: (context) => new RecorderPlayer(payload),
//                ),
//              );
//            },
//          )
//        ],
//      ),
//    );
//  }




}


class LocalNotification  {

 MyApp myApp=MyApp();


  void showNotificationAfter( int day,int hour ,int minute,int id ,String title,String body ,String payload)async{
    await notificationAfter(day,hour,minute, id , title, body , payload);
  }
  Future<void> notificationAfter( int day,int hour ,int minute,int id ,String title,String body ,String payload) async{
    var timeDelayed =DateTime.now().add(Duration(days: day,hours: hour,minutes: minute));
    var androidNotificationDetails = AndroidNotificationDetails(
        '$id',title,body,
        importance: Importance.Max,
        priority: Priority.High,
        ongoing: true,
        enableVibration: true,
        ticker: 'test ticker',
        playSound: true);
    IOSNotificationDetails iosNotificationDetails=IOSNotificationDetails(
        presentSound: true
    );
    NotificationDetails notificationDetails  =NotificationDetails(androidNotificationDetails,iosNotificationDetails);
    await myApp.flutterLocalNotificationsPlugin.schedule(id,title,body,timeDelayed,notificationDetails,payload: payload);
  }

  void showNotification(int id ,String title,String body ,String payload)async{
    await notification( id , title, body , payload);
  }
  Future<void> notification( int id ,String title,String body ,String payload) async{
    var androidNotificationDetails = AndroidNotificationDetails(
        '$id',title,body,
        importance: Importance.Max,
        priority: Priority.High,
        ongoing: true,
        enableVibration: true,
        ticker: 'test ticker',
        playSound: true);
    IOSNotificationDetails iosNotificationDetails=IOSNotificationDetails(
        presentSound: true
    );
    NotificationDetails notificationDetails  =
    NotificationDetails(androidNotificationDetails,iosNotificationDetails);
    await myApp.flutterLocalNotificationsPlugin.show(id,title,body,notificationDetails,payload: payload);
  }

}






