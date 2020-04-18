import 'package:alarm_recorder/notes/note_list.dart';
import 'package:alarm_recorder/notes/textFieldCustom.dart';
import 'package:alarm_recorder/recorder/recorder.dart';
import 'package:alarm_recorder/recorder/recorder_player.dart';
import 'package:alarm_recorder/utils/screen_size.dart';
import 'package:alarm_recorder/utils/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_localizations.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  WidgetSize fontWidgetSize;
  SizeConfig sizeConfig;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    sizeConfig = SizeConfig(context);
    fontWidgetSize = WidgetSize(sizeConfig);
    double raduis = sizeConfig.screenWidth * 0.10;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: sizeConfig.screenHeight * .2,
              color: Colors.blueAccent,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: sizeConfig.screenWidth * .15,
                    height: sizeConfig.screenWidth * .15,
                    child: CircleAvatar(
                        maxRadius: 10,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.note)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "My Memory",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return MyTextFieldCustom(false, false, false);
                }));
              },
              leading: Icon(
                Icons.note_add,
                color: Colors.blueAccent,
              ),
              title: Text("add note"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return NoteList();
                }));
              },
              leading: Icon(
                Icons.note,
                color: Colors.blueAccent,
              ),
              title: Text("all notes"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return RecorderScreen();
                }));
              },
              leading: Icon(
                Icons.record_voice_over,
                color: Colors.blueAccent,
              ),
              title: Text("record voice"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return RecorderPlayer("");
                }));
              },
              leading: Icon(
                Icons.queue_music,
                color: Colors.blueAccent,
              ),
              title: Text("recorder list "),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return MySettings();
                }));
              },
              leading: Icon(
                Icons.settings,
                color: Colors.blueAccent,
              ),
              title: Text("Settings"),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: sizeConfig.screenWidth,
              height: sizeConfig.screenHeight * .32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.blueAccent,
                      Color(0xFF74b9ff),
                      Colors.blueAccent,
                    ]),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(raduis),
                    bottomLeft: Radius.circular(raduis)),
              ),
              child: Padding(
                padding: EdgeInsets.all(sizeConfig.screenWidth * .05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                          child: Icon(
                            Icons.list,
                            color: Colors.white,
                            size: fontWidgetSize.icone,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MySettings();
                                }));
                          },
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: fontWidgetSize.icone,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, left: 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).translate('pre_name'),
                            style: TextStyle(
                                fontSize: fontWidgetSize.titleFontSize,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                          Text(
                            AppLocalizations.of(context).translate('app_name'),
                            style: TextStyle(
                                fontSize: fontWidgetSize.titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: sizeConfig.screenHeight * 0.1,
                  right: sizeConfig.screenWidth * 0.01,
                  left: sizeConfig.screenWidth * 0.01),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:
                    EdgeInsets.only(left: sizeConfig.screenWidth * .025),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
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
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(left: sizeConfig.screenWidth * .025),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return MyTextFieldCustom(false, true, true);
                              }));
                            },
                            child: locationContainer()),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return MyTextFieldCustom(false, true, false);
                            }));
                          },
                          child: cameraContainer(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget locationContainer() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        height: sizeConfig.screenHeight * .2,
        width: sizeConfig.screenWidth * .4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 2), blurRadius: 10.0)
          ],
          color: Color(0xFFF5F7FB),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/local.png",
              height: sizeConfig.screenHeight * .11,
              width: sizeConfig.screenWidth * .25,
            ),
            SizedBox(
              width: 50,
            ),
            Text(
              AppLocalizations.of(context).translate('location_main'),
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: fontWidgetSize.titleFontSize - 10,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget recordContainer() {
    return Container(
      height: sizeConfig.screenHeight * .2,
      width: sizeConfig.screenWidth * .4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 2), blurRadius: 10.0)
          ],
          color: Color(0xFFF5F7FB)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/recordxd.png",
            height: sizeConfig.screenHeight * .11,
            width: sizeConfig.screenWidth * .25,
          ),
          SizedBox(
            width: 50,
          ),
          Text(
            AppLocalizations.of(context).translate('recorder_main'),
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: fontWidgetSize.titleFontSize - 10,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget noteContainer() {
    return Container(
      height: sizeConfig.screenHeight * .2,
      width: sizeConfig.screenWidth * .4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 2), blurRadius: 10.0)
          ],
          color: Color(0xFFF5F7FB)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/nots.png",
            height: sizeConfig.screenHeight * .13,
            width: sizeConfig.screenWidth * .25,
          ),
          Text(
            AppLocalizations.of(context).translate('note_main'),
            style: TextStyle(
                color: Color(0xFF417BFb),
                fontSize: fontWidgetSize.titleFontSize - 10,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget cameraContainer() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        height: sizeConfig.screenHeight * .2,
        width: sizeConfig.screenWidth * .4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 2), blurRadius: 10.0)
            ],
            color: Color(0xFFF5F7FB)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/cam.png",
              height: sizeConfig.screenHeight * .13,
              width: sizeConfig.screenWidth * .25,
            ),
            Text(
              AppLocalizations.of(context).translate('camera_main'),
              style: TextStyle(
                  color: Color(0xFF417BFb),
                  fontSize: fontWidgetSize.titleFontSize - 10,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
