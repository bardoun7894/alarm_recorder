import 'package:alarm_recorder/recorder_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification  {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  BuildContext context;

  LocalNotification(){
    initializing();
  }
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
       enableVibration: true,
       ticker: 'test ticker',playSound: true);
     IOSNotificationDetails iosNotificationDetails=IOSNotificationDetails();
     NotificationDetails notificationDetails  =NotificationDetails(androidNotificationDetails,iosNotificationDetails);
     await flutterLocalNotificationsPlugin.schedule(id,title,body,timeDelayed,notificationDetails,payload: payload);
}

Future onSelectNotification(String payload){
  if (payload != null) {
    debugPrint('Notification payload: $payload');
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return RecorderPlayer(payload);
    }));
  }
//we can navigate to other screen
}


Future onDidReceiveLocalNotification(int id ,String title,String body ,String payload) async{
    return Future.value(1);
}

}
