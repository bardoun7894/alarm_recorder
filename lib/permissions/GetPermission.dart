import 'package:alarm_recorder/utils/getlocation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetLocation location =new GetLocation();

getPermissionLocationStatus(context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  PermissionStatus status = await Permission.locationWhenInUse.status;
  var isDisabled = await Permission.locationWhenInUse.serviceStatus.isDisabled;
  if (isDisabled) {
    Future.delayed(Duration(seconds: 3)).then((x) {
      location.showSaveDialog(context, status, sharedPreferences,isDisabled);
    });
  }
  print("$status");
  switch (status) {
    case PermissionStatus.undetermined:
      await Permission.locationWhenInUse.request();
      break;
    case PermissionStatus.granted:
      location.mapEventToState(status.isGranted);
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
          location.getCurrentPosition();
        }
      }
      break;
  }
}
getPermissionRecorderStatus(Function fn) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.microphone,
    Permission.storage,
  ].request();
  switch(statuses[Permission.microphone]){
    case PermissionStatus.undetermined:
      await Permission.microphone.request();
      break;
    case PermissionStatus.granted:
      fn();
      break;
    case PermissionStatus.denied:
      await Permission.microphone.request();
      // TODO: Handle this case.
      break;
    case PermissionStatus.restricted:
      await Permission.microphone.request();
      // TODO: Handle this case.
      break;
    case PermissionStatus.permanentlyDenied:
    // TODO: Handle this case.
      await Permission.microphone.request();
      break;
  }
  switch(statuses[Permission.storage]){
    case PermissionStatus.undetermined:
      await Permission.storage.request();
      break;
    case PermissionStatus.granted:
    // TODO: Handle this case.
      break;
    case PermissionStatus.denied:
      await Permission.storage.request();
      break;
    case PermissionStatus.restricted:
      await Permission.storage.request();
      break;
    case PermissionStatus.permanentlyDenied:
      await Permission.storage.request();
      break;
  }

}
getPermissionPhotosStatus(Function method,Function requestPermission,Function permissionWidgetStatus) async {
  var status;
  permissionWidgetStatus(status);
  switch (status) {
    case PermissionStatus.undetermined:
      requestPermission();
      method();
      break;
    case PermissionStatus.granted:
      method();
      break;
    case PermissionStatus.denied:
      requestPermission();
      method();
      break;
    case PermissionStatus.restricted:
      requestPermission();
      method();
      break;
    case PermissionStatus.permanentlyDenied:
      requestPermission();
      method();
      break;
  }
}

firstPermissionGet()async{
  Map<Permission, PermissionStatus> statuses = await [
    Permission.microphone,
    Permission.location,
    Permission.mediaLibrary,
    Permission.camera,
    Permission.storage,
  ].request();
  switch(statuses[Permission.microphone]){
    case PermissionStatus.undetermined:
      await Permission.microphone.request();
      break;
    case PermissionStatus.granted:

      break;
    case PermissionStatus.denied:
      await Permission.microphone.request();
      // TODO: Handle this case.
      break;
    case PermissionStatus.restricted:
      await Permission.microphone.request();
      // TODO: Handle this case.
      break;
    case PermissionStatus.permanentlyDenied:
    // TODO: Handle this case.
      await Permission.microphone.request();
      break;
  }
  switch(statuses[Permission.storage]){
    case PermissionStatus.undetermined:
      await Permission.storage.request();
      break;
    case PermissionStatus.granted:
    // TODO: Handle this case.
      break;
    case PermissionStatus.denied:
      await Permission.storage.request();
      break;
    case PermissionStatus.restricted:
      await Permission.storage.request();
      break;
    case PermissionStatus.permanentlyDenied:
      await Permission.storage.request();
      break;
  }
  switch(statuses[Permission.mediaLibrary]){
    case PermissionStatus.undetermined:
      await Permission.mediaLibrary.request();
      break;
    case PermissionStatus.granted:
    // TODO: Handle this case.
      break;
    case PermissionStatus.denied:
      await Permission.mediaLibrary.request();
      break;
    case PermissionStatus.restricted:
      await Permission.mediaLibrary.request();
      break;
    case PermissionStatus.permanentlyDenied:
      await Permission.mediaLibrary.request();
      break;
  }
  switch(statuses[Permission.camera]){
    case PermissionStatus.undetermined:
      await Permission.camera.request();
      break;
    case PermissionStatus.granted:
    // TODO: Handle this case.
      break;
    case PermissionStatus.denied:
      await Permission.camera.request();
      break;
    case PermissionStatus.restricted:
      await Permission.camera.request();
      break;
    case PermissionStatus.permanentlyDenied:
      await Permission.camera.request();
      break;
  }
  switch(statuses[Permission.location]){
    case PermissionStatus.undetermined:
      await Permission.location.request();
      break;
    case PermissionStatus.granted:
    // TODO: Handle this case.
      break;
    case PermissionStatus.denied:
      await Permission.location.request();
      break;
    case PermissionStatus.restricted:
      await Permission.location.request();
      break;
    case PermissionStatus.permanentlyDenied:
      await Permission.location.request();
      break;
  }
}

