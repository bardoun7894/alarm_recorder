import 'dart:async';
import 'package:alarm_recorder/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
 

  class GetLocation {
 


  getPermissionStatus(context) async {
    var status = await Permission.locationWhenInUse.status;
    var isDisabled = await Permission.locationWhenInUse.serviceStatus.isDisabled;
       if (isDisabled){
         showSaveDialog(context);
       }
    print("$status ll");
    switch (status) {
      case PermissionStatus.undetermined:
        // TODO: Handle this case.
        await Permission.locationWhenInUse.request();
        break;
      case PermissionStatus.granted:
      getCurrentPosition();
        break;
      case PermissionStatus.denied:
        await Permission.locationWhenInUse.request();
        break;
      case PermissionStatus.restricted:
        // TODO: Handle this case.
        break;
      case PermissionStatus.permanentlyDenied:
           openAppSettings();
        print("slsls");
        break;
    }
  }

  Future<Position> getCurrentPosition() async {
    Position startPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return startPosition;
  }



  getLastPosition(int id,String title,String body,String payload,_localNotification) async {
    Position p = await getCurrentPosition();
    double currentlat = p.latitude;
    double currentlong = p.longitude;

    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 5);
    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) async {

      double endlat = position.latitude;
      double endlong = position.longitude;
      print("${position.longitude}  movee    ");
      print("${p.longitude}  current ");
       double distanceInMeters = await Geolocator()
          .distanceBetween(currentlat, currentlong, endlat, endlong);

      print("distamce mettter  $distanceInMeters");
      // _localNotification.showNotification(  0,"3",   "you", "you");
      print(position == null ? 'Unknown' : "$distanceInMeters");
      if (distanceInMeters > 15.0) {
        print(" you are so far");

       _localNotification.showNotification( id,title,body,payload);
      }
    });
    return positionStream;
  }

  Future<bool> showSaveDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 280.0,
              width: 200.0,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 130.0,
                      ),
                      Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          color: Color(0xFF417BFb),
                        ),
                      ),
                      Positioned(
                        top: 50.0,
                        left: 94.0,
                        child: Container(
                          height: 90.0,
                          width: 90.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/local.png'),
                            ),
                            borderRadius: BorderRadius.circular(45.0),
//
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context).translate('dialog_settings'),
                      style: TextStyle(
                          color: Color(0xFF417BFb),
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0),
                    ),
                  ),
                  SizedBox(height: 38),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          openAppSettings();
                        },
                        color: Colors.teal,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).translate("yes"),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.grey,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).translate("no"),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
