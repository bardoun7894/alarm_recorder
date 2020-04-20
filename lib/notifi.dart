  
import 'package:alarm_recorder/recorder/recorder_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification  {
  final MethodChannel platform =
  MethodChannel('crossingthestreams.io/resourceResolver');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  BuildContext context;

  void initializing() async{
    androidInitializationSettings=AndroidInitializationSettings('app_icon');
    iosInitializationSettings=IOSInitializationSettings(onDidReceiveLocalNotification:onDidReceiveLocalNotification );
    initializationSettings=InitializationSettings(androidInitializationSettings,iosInitializationSettings);
   await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
  }


void showNotificationAfter( int day,int hour ,int minute,int id ,String title,String body ,String payload)async{
    await notificationAfter(day,hour,minute, id , title, body , payload);
}
Future<void> notificationAfter( int day,int hour ,int minute,int id ,String title,String body ,String payload) async{

   var timeDelayed =DateTime.now().add(Duration(days: day,hours: hour,minutes: minute));
  var androidNotificationDetails = AndroidNotificationDetails(
      'channel_ID', 'channel name', 'channel description',
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
     await flutterLocalNotificationsPlugin.schedule(id,title,body,timeDelayed,notificationDetails,payload: payload);
}


void showNotification(int id ,String title,String body ,String payload)async{
    await notification( id , title, body , payload);
}
Future<void> notification( int id ,String title,String body ,String payload) async{
  var androidNotificationDetails = AndroidNotificationDetails(
      'second channel_ID', ' second channel name', 'second channel description',
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
     await flutterLocalNotificationsPlugin.show(id,title,body,notificationDetails,payload: payload);
}

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new RecorderPlayer(payload)),
    );
  }


  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new RecorderPlayer(payload),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
