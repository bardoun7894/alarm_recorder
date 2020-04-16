import 'package:alarm_recorder/recorder.dart';
import 'package:alarm_recorder/utils/screen_size.dart';
import 'package:alarm_recorder/utils/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'notes/note_list.dart';
import 'notes/textFieldCustom.dart';
import 'package:alarm_recorder/utils/getlocation.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

  WidgetSize fontWidgetSize;
  SizeConfig sizeConfig;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    sizeConfig = SizeConfig(context);
    fontWidgetSize = WidgetSize(sizeConfig);
     double raduis = sizeConfig.screenWidth * 0.10;
    return Scaffold(

      body: Container(

        child: Column(
          children: <Widget>[
            Container(
              width:sizeConfig.screenWidth,
              height: sizeConfig.screenHeight*.32,
              decoration: BoxDecoration(
                  color:Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomRight:Radius.circular(raduis),
                  bottomLeft:Radius.circular(raduis)
                ),
              ),

              child: Padding(
                padding:  EdgeInsets.all(sizeConfig.screenWidth*.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.list,color: Colors.white,size:fontWidgetSize.icone,),
                        Icon(Icons.settings,color: Colors.white,size:fontWidgetSize.icone,)
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:50.0,left: 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'My',
                            style: TextStyle(fontSize: fontWidgetSize.titleFontSize, fontWeight: FontWeight.normal,color: Colors.white),
                          ),
                          Text(
                            ' Memory',
                            style: TextStyle(fontSize: fontWidgetSize.titleFontSize, fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                     ),),

            Padding(
              padding:   EdgeInsets.only(top:sizeConfig.screenHeight*0.1),
              child: Column(
                children: <Widget>[


                  Row(children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return NoteList();
                          }));
                        },
                        child: noteContainer()),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return RecorderScreen();
                        }));
                      },
                      child: recordContainer(),
                    ),
                  ],)     ,
                  Padding(
                    padding:  EdgeInsets.only(left:sizeConfig.screenWidth*.025),
                    child: Row(children: <Widget>[
                      InkWell(
                          onTap: () {
                    Navigator.of(context) .push(MaterialPageRoute(builder: (context) {
                              return GetLocation();
                            }));
                          },
                          child: locationContainer()),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return MyTextFieldCustom(false,true);
                          }));
                        },
                        child: cameraContainer(),
                      ),
                    ],),
                  )


                   ],
              ),
            ),


          ],
        ),
      ),

    );
  
 
  }
  Widget recordContainer(){
                return Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Container(

                    height:sizeConfig.screenHeight*.2,
                    width:  sizeConfig.screenWidth*.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 10.0)
                        ],
                        color: Color(0xFFF5F7FB)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/recordxd.png",
                          height:sizeConfig.screenHeight*.11,
                          width:  sizeConfig.screenWidth*.25,
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "Recorder",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize:fontWidgetSize.titleFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
             
  }
  Widget locationContainer(){
                return Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Container(

                    height:sizeConfig.screenHeight*.2,
                    width:  sizeConfig.screenWidth*.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 10.0)
                        ],
                        color: Color(0xFFF5F7FB),),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/local.png",
                          height:sizeConfig.screenHeight*.11,
                          width:  sizeConfig.screenWidth*.25,
                                   ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "location",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize:fontWidgetSize.titleFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
           }
    Widget noteContainer(){
      return   Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                child: Container(
                  height:sizeConfig.screenHeight*.2,
                  width:  sizeConfig.screenWidth*.4,
                   decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 10.0)
                      ],
                      color: Color(0xFFF5F7FB)),
                     child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: <Widget>[
                      Image.asset("assets/nots.png",
                        height:sizeConfig.screenHeight*.13,
                        width:  sizeConfig.screenWidth*.25,
                      ),
                         Padding(
                           padding: const EdgeInsets.only(left:25.0,top:10),
                           child: Text(
                                 "Note",
                              style: TextStyle(
                                color: Color(0xFF417BFb),
                                  fontSize:fontWidgetSize.titleFontSize,
                                fontWeight: FontWeight.bold),
                      ),
                         ),
                          
                    ],
                  ),
                ),
              );
         
    }
    Widget cameraContainer(){
      return   Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                child: Container(
                  height:sizeConfig.screenHeight*.2,
                  width:  sizeConfig.screenWidth*.4,
                   decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 10.0)
                              ],
                      color: Color(0xFFF5F7FB)),
                     child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: <Widget>[
                      Image.asset("assets/cam.png",
                        height:sizeConfig.screenHeight*.13,
                        width:  sizeConfig.screenWidth*.25,
                      ),
                         Padding(
                           padding: const EdgeInsets.only(left:25.0,top:10),
                           child: Text(
                                 "Camera    ",
                              style: TextStyle(
                                color: Color(0xFF417BFb),
                                  fontSize:fontWidgetSize.titleFontSize,
                                fontWeight: FontWeight.bold),
                      ),
                         ),

                    ],
                  ),
                ),
              );

    }

}
