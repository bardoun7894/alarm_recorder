import 'dart:async';
import 'dart:io';
import 'dart:ui';
//
// import 'package:background_locator/background_locator.dart';
// import 'package:background_locator/settings/ios_settings.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg ;
import 'package:alarm_recorder/location/getlocation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'location_callback_handler.dart';

LocalNotification _localNotification = LocalNotification();
String logStr = '';
List<LatLng> points = List();
bool isRunning;
GetLocation getLocation =GetLocation();

 Future<bool> permetIsDisabled()async{
  var a = await Permission.locationAlways.serviceStatus.isDisabled;
  return a ;
   }




void onStart() async {
  // if (await _checkLocationPermission()) {
  //   _startLocator();
  //   final _isRunning = await BackgroundLocator.isServiceRunning();
  //     isRunning = _isRunning;
  //   print('Running ${isRunning.toString()}');
  // } else {
  //   // show error
  // }
}

// void onStop() async {
//   BackgroundLocator.unRegisterLocationUpdate();
//   IsolateNameServer.removePortNameMapping(LocationCallbackHandler.isolateName);
//   final _isRunning = await BackgroundLocator.isServiceRunning();
//     isRunning = _isRunning;
//   print('Running ${isRunning.toString()}');
// }





//
// disposeLocation() {
//   BackgroundLocator.unRegisterLocationUpdate();
//   IsolateNameServer.removePortNameMapping(LocationCallbackHandler.isolateName);
// }
//    backgroundLocationforAndroid(){
//      onStart();
//      LocationCallbackHandler.getPort().listen(
//            (dynamic data) async {
//          if (data == null) return;
//          // await BackgroundLocator.updateNotificationText(
//          //     title: "new location received",
//          //     msg: "${DateTime.now()}",
//          //     bigMsg: "${data.latitude}, ${data.longitude}");
//          if (data != null) {
//            print("location found");
//            print(data);
//            logStr += ' ${data.latitude}, ${data.longitude}, ${data.isMocked}, ' +
//                DateTime.now().hour.toString() +
//                ":" +
//                DateTime.now().minute.toString() +
//                ":" +
//                DateTime.now().second.toString() +
//                "\n";
//            var point = LatLng(data.latitude, data.longitude);
//            points.add(point);
//            print("location 1  found");
//
//          }
//
//        },
//      );
//      initPlatformState();
//    }
// Future<void> initPlatformState() async {
//   print('Initializing...');
//   await BackgroundLocator.initialize();
//   print('Initialization done');
//   final _isRunning = await BackgroundLocator.isServiceRunning();
//     isRunning = _isRunning;
//   print('Running ${isRunning.toString()}');
// }
getOdometer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double doubleValue = prefs.getDouble('odometer');
  return doubleValue;
}
void getdistanceBetween (int id, String title, String body, String imgString, String payload, double xMeter,List list) async {
   double odo = await getOdometer();
  if (Platform.isIOS) {

     print("run ${odo}");

     if (odo >= xMeter) {
     print(getOdometer());
     bg.BackgroundGeolocation.setOdometer(0);
      print("F");
      notif(id, title, body, imgString, payload, xMeter);
      bg.BackgroundGeolocation.destroyLocations();
      bg.BackgroundGeolocation.stop();
    }
     }
     else
     {
    double distanceInMeters = await Geolocator.distanceBetween(
        list.first.latitude, list.first.longitude, list.last.latitude, list.last.longitude);
    print("distance meter $distanceInMeters");
    print("$id $title $body");
    if (distanceInMeters >= xMeter) {
      print(" you are so far");
      notif(id, title, body, imgString, payload, xMeter);
      await flutterLocalNotificationsPlugin.cancel(id);
      // getLocation.onStop();
    }
  }
}
notif(int id, String title, String body, String imgString, String payload, double xMeter) async {
    _localNotification.showNotification( id, title, body, imgString, payload) ;
      }

getcurrent()async{
 await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}