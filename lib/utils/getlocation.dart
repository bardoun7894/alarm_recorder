import 'dart:async';
import 'dart:io';

import 'package:alarm_recorder/Translate/app_localizations.dart';

import 'package:alarm_recorder/utils/screen_size.dart';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetLocation  extends ChangeNotifier{
  StreamSubscription<Position> _positionStream;

  bool _fabClicked=false;
final _fabStateController=StreamController<bool>();
StreamSink<bool> get _inFabClick=>_fabStateController.sink;
Stream<bool> get FabClick=>_fabStateController.stream;

final _fabEventController =StreamController<bool>();
Sink<bool> get fabClickEventSink =>_fabEventController.sink;

GetLocation(){
  _fabEventController.stream.listen(_mapEventToState);
}
  void _mapEventToState(bool event) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isDisabled = await Permission.locationAlways.serviceStatus.isDisabled;
    if(!isDisabled){
      if(event){
        _fabClicked=true;
        getCurrentPosition();
        sharedPreferences.setBool("fabClicked", true);
        }else{
        _fabClicked=false;
        sharedPreferences.setBool("fabClicked", false);
        }
        }else{
          print(" disabled");
          }
    _inFabClick.add(_fabClicked);
          }

  getPermissionStatus(context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    PermissionStatus status = await Permission.locationWhenInUse.status;
    var isDisabled = await Permission.locationWhenInUse.serviceStatus.isDisabled;
    if (isDisabled) {
      Future.delayed(Duration(seconds: 3)).then((x) {
        showSaveDialog(context, status, sharedPreferences, isDisabled);
      });
    }

    print("$status");
    switch (status) {
      case PermissionStatus.undetermined:
        await Permission.locationWhenInUse.request();
        break;
      case PermissionStatus.granted:
        _mapEventToState(status.isGranted);
        break;
      case PermissionStatus.denied:
        await Permission.locationWhenInUse.request();
        break;
      case PermissionStatus.restricted:
        // TODO: Handle this case.
        break;
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        if (status.isGranted) {
          if (!isDisabled) {
            sharedPreferences.setBool("fabClicked", true);
            getCurrentPosition();
          }
        }
        break;
        }
      }

  Future<Position> getCurrentPosition() async {
    Position startPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
         print("startPosition $startPosition");
    return startPosition;
  }

  bool isListening() => !(_positionStream == null || _positionStream.isPaused);

   getLastPosition(int id, String title, String body, String imgString, String payload, _localNotification, double xMeter) async {
    Position p = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double currentlat = p.latitude;
    double currentlong = p.longitude;

    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter:10);
    notifyListeners();
    if (_positionStream == null) {
      _positionStream = geolocator.getPositionStream(locationOptions).listen((Position position) async {
        double endlat = position.latitude;
        double endlong = position.longitude;

        double distanceInMeters = await Geolocator().distanceBetween(currentlat,currentlong, endlat, endlong);
        print("distance meter  $distanceInMeters");
        if (distanceInMeters >= xMeter) {
          print(" you are so far");
          _localNotification.showNotification( id, title, body, imgString, payload) ;
          _positionStream.pause();
          _positionStream.cancel();
        }
      });
    }

  }

  bool _isListening() => !(_positionStream == null || _positionStream.isPaused);

  stopLocation() {
    if (_isListening()) {
      _positionStream.pause();
    }
  }

  disposeLocation() {
    if (_positionStream != null) {
      _positionStream.cancel();
      _positionStream = null;
    }
//    if (positionStream != null) {
//      positionStream.pause();
//      positionStream.cancel();
//      positionStream = null;
//    }
  }
  disposeFab(){
    _fabStateController.close();
    _fabEventController.close();
  }



  Future<bool> showSaveDialog(   context, PermissionStatus status, shared, isDisabled){
    SizeConfig sizeConfig = SizeConfig(context);
    WidgetSize fontWidgetSize = WidgetSize(sizeConfig);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: sizeConfig.screenHeight * .45,
              width: sizeConfig.screenHeight * .4,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(height: sizeConfig.screenHeight * .22),
                      Container(
                        height: sizeConfig.screenHeight * .15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          color: Color(0xFF417BFb),
                        ),
                      ),
                      Positioned(
                        top: sizeConfig.screenHeight * .09,
                        left: sizeConfig.screenWidth * .25,
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
                          fontSize: fontWidgetSize.bodyFontSize - 8),
                    ),
                  ),
                  SizedBox(height: sizeConfig.screenHeight * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          settings(context);

                          _mapEventToState(status.isGranted);},
                        color: Colors.teal,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).translate("ok"),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: fontWidgetSize.bodyFontSize - 8,
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
                                fontSize: fontWidgetSize.bodyFontSize - 8,
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

  Future settings(context) async {
    if (Platform.isAndroid) {
      final AndroidIntent intent =
          AndroidIntent(action: 'android.settings.LOCATION_SOURCE_SETTINGS');
      await intent.launch();
      Navigator.of(context, rootNavigator: true).pop();
    } else if (Platform.isIOS) {
      await openAppSettings();
    }
  }

}
