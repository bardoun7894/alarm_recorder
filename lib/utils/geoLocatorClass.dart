import 'dart:async';

import 'package:alarm_recorder/utils/getlocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

LocalNotification _localNotification = LocalNotification();
GetLocation getLocation =GetLocation();
 Future<bool> permetIsDisabled()async{
  var a = await Permission.locationAlways.serviceStatus.isDisabled;
  return a ;
}
void getdistanceBetween(currentlat,currentlong, endlat, endlong ,int id, String title, String body, String imgString, String payload, double xMeter) async {
      double distanceInMeters =   await Geolocator.distanceBetween(currentlat,currentlong, endlat, endlong);

      print("distance meter $distanceInMeters");
      print("$id $title $body") ;
      if (distanceInMeters >= xMeter) {
        print(" you are so far");
        notif(id, title, body, imgString, payload,xMeter);
        Future.delayed(Duration(seconds: 5), (){
          getLocation.onStop();
        });

      }
}
notif(int id, String title, String body, String imgString, String payload, double xMeter) async {

    _localNotification.showNotification( id, title, body, imgString, payload) ;


}

getcurrent()async{
 await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}