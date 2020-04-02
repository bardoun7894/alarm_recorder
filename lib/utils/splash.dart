import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
      color:Color(0xFF417BFb),
           child: Center(
           child: SpinKitDoubleBounce(color:Colors.white,size: 200,),),
      ),
    );
  }
}