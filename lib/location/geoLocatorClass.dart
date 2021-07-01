import 'dart:async';
import 'dart:io';
import 'dart:ui';
// import 'package:background_locator/background_locator.dart';
// import 'package:background_locator/settings/ios_settings.dart';
// import 'package:background_locator/background_locator.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg ;
import 'package:alarm_recorder/location/getlocation.dart';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
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

// getOdometer() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   double doubleValue = prefs.getDouble('odometer');
//   return doubleValue;
// }
void getdistanceBetween (int id, String title, String body, String imgString, String payload, double xMeter) async {

  if (Platform.isIOS) {
double odo =await bg.BackgroundGeolocation.odometer;
     if ( odo >= xMeter) {

     bg.BackgroundGeolocation.setOdometer(0);
      notif(id, title, body, imgString, payload, xMeter);
      bg.BackgroundGeolocation.destroyLocations();
      bg.BackgroundGeolocation.stop();
    }
     }

}
notif(int id, String title, String body, String imgString, String payload, double xMeter) async {
  _localNotification.showNotification( id, title, body, imgString, payload) ;
  }

getcurrent()async{
 await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}