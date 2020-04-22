//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:rxdart/rxdart.dart';
//
//import 'model/Note.dart';
//import 'notes/textFieldCustom.dart';
//
//class NotificationManager{
//
//  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//  FlutterLocalNotificationsPlugin();
//
//// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
//  final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =  BehaviorSubject<ReceivedNotification>();
//
//  final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
//
//
//
//
//  dispose(){
//  didReceiveLocalNotificationSubject.close();
//  selectNotificationSubject.close();
//}
//
//
//  void showNotificationAfter( int day,int hour ,int minute,int id,String imgString ,String title,String body )async{
//    await notificationAfter(day,hour,minute, id ,imgString, title, body );
//  }
//  Future<void> notificationAfter( int day,int hour ,int minute,int id ,String imgString ,String title,String body) async{
//    var timeDelayed =DateTime.now().add(Duration(days: day,hours: hour,minutes: minute));
//    var androidNotificationDetails = AndroidNotificationDetails(
//        '$id',title,body,
//        importance: Importance.Max,
//        priority: Priority.High,
//        ongoing: true,
//        enableVibration: true,
//        ticker: 'test ticker',
//        playSound: true);
//    IOSNotificationDetails iosNotificationDetails=IOSNotificationDetails(
//        presentSound: true
//    );
//    NotificationDetails notificationDetails  =NotificationDetails(androidNotificationDetails,iosNotificationDetails);
//    Note newNote =Note(id:id,imagePath: imgString,title: title,description: body);
//    String noteJsonString = newNote.toRawJson();
//
//    await flutterLocalNotificationsPlugin.schedule(id,title,body,timeDelayed,notificationDetails,payload:noteJsonString);
//  }
//
//
//
//  void showNotification(int id ,String title,String body ,String payload)async{
//    await notification( id , title, body , payload);
//  }
//  Future<void> notification( int id ,String title,String body ,String payload) async{
//    var androidNotificationDetails = AndroidNotificationDetails(
//        '$id',title,body,
//        importance: Importance.Max,
//        priority: Priority.High,
//        ongoing: true,
//        enableVibration: true,
//        ticker: 'test ticker',
//        playSound: true);
//    IOSNotificationDetails iosNotificationDetails=IOSNotificationDetails(
//        presentSound: true
//    );
//    NotificationDetails notificationDetails  =
//    NotificationDetails(androidNotificationDetails,iosNotificationDetails);
//    await flutterLocalNotificationsPlugin.show(id,title,body,notificationDetails,payload: payload);
//  }
//
//}
//
//
//void _requestIOSPermissions() {
//  widget.notificationManager.flutterLocalNotificationsPlugin
//      .resolvePlatformSpecificImplementation<
//      IOSFlutterLocalNotificationsPlugin>()
//      ?.requestPermissions(
//    alert: true,
//    badge: true,
//    sound: true,
//  );
//}
//
//void _configureDidReceiveLocalNotificationSubject() {
//  widget.notificationManager.didReceiveLocalNotificationSubject.stream
//      .listen((ReceivedNotification receivedNotification) async {
//    await showDialog(
//      context: context,
//      builder: (BuildContext context) => CupertinoAlertDialog(
//        title: receivedNotification.title != null
//            ? Text(receivedNotification.title)
//            : null,
//        content: receivedNotification.body != null
//            ? Text(receivedNotification.body)
//            : null,
//        actions: [
//          CupertinoDialogAction(
//            isDefaultAction: true,
//            child: Text('Ok'),
//            onPressed: () async {
//              Navigator.of(context, rootNavigator: true).pop();
//              await Navigator.push(  context,  MaterialPageRoute(
//
//                builder: (context) =>  MyTextFieldCustom(true,true,true,payload: receivedNotification.payload,),
//              ),
//              );
//            },
//          )
//        ],
//      ),
//    );
//  });
//}
//
//void _configureSelectNotificationSubject() {
//  widget.notificationManager.selectNotificationSubject.stream.listen((String payload) async {
//    print(payload);
//    Note note = Note.fromRawJson(payload);
//    await Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => MyTextFieldCustom(true,true,false,note: note,)),
//
//    );
//  });
//}
//
//
//
//class ReceivedNotification {
//  final int id;
//  final String title;
//  final String body;
//  final String payload;
//
//  ReceivedNotification(
//      {@required this.id,
//        @required this.title,
//        @required this.body,
//        @required this.payload});
//}