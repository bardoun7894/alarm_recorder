import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
class GetLocation extends StatefulWidget {
  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  checKGps() async{

  }
  getCurrentPosition()async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude);
    print(position.longitude);
    print(position.accuracy);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: FlatButton(child: Text("gps"), onPressed: () {
            getCurrentPosition();
          },),
        ),
      ),
    );
  }
}
