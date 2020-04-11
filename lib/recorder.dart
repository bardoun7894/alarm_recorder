import 'dart:async';

import 'package:alarm_recorder/databases/RegisterDatabase.dart';
import 'package:alarm_recorder/model/recordModel.dart';
import 'package:alarm_recorder/recorder_player.dart';
import 'package:alarm_recorder/utils/screen_size.dart';
import 'package:alarm_recorder/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io' as io;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'notifi.dart';

class RecorderScreen extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  RecorderScreen({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _RecorderScreenState createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  int currentIcon = 0;
  double height;
  double width;
  WidgetSize fontWidgetSize;
  SizeConfig sizeConfig;
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  LocalNotification _localNotification = LocalNotification();
  String name="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        name = DateTime.now().millisecondsSinceEpoch.toString();
        String customPath = '/$name';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig = SizeConfig(context);
    fontWidgetSize = WidgetSize(sizeConfig);

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: sizeConfig.screenWidth,
        height: sizeConfig.screenHeight,
        child: Stack(children: <Widget>[
          Container(
            width: sizeConfig.screenWidth,
            height: sizeConfig.screenHeight * 0.48,
            decoration: BoxDecoration(
                color: Color(0xFF417BFb),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(sizeConfig.screenWidth * .2),
                    bottomRight: Radius.circular(sizeConfig.screenWidth * .2))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: sizeConfig.screenHeight * .05,
                      left: sizeConfig.screenWidth * .02,
                      right: sizeConfig.screenWidth * .02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return RecorderPlayer("");
                            }));
                          },
                          child: Icon(
                            Icons.list,
                            color: Colors.white,
                            size: fontWidgetSize.icone,
                          )),
                      Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: fontWidgetSize.icone,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: sizeConfig.screenHeight * .12),
                  child: Column(
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                            fontFamily: 'sans sherif',
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: fontWidgetSize.titleFontSize),
                      ),
                      SizedBox(
                        height: sizeConfig.screenHeight * .05,
                      ),
                      Text(
                        _current?.duration.toString().split(".")[0],
                        style: TextStyle(
                            fontFamily: 'sans sherif',
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: fontWidgetSize.titleFontSize + 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: sizeConfig.screenHeight * -0.1,
              left: sizeConfig.screenWidth * (1 / 20),
              child: reco()),
        ]),
      ),
    );
  }

  reco() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Center(
          child: currentIcon == 0
              ? Container(
                  color: Colors.white,
                  width: sizeConfig.screenWidth * .92,
                  height: sizeConfig.screenWidth * .92,
                )
              : animationReco(),
        ),
        Center(
          child: InkWell(
            onTap: () {
              _currentStatus != RecordingStatus.Unset ? _stop : null;
              setState(() {
                if (currentIcon == 0) {
                  _start();
                  currentIcon = 1;
                } else {
                  ShowCoupons(context,_stop,currentIcon);

                  //   ShowCoupons(context);
                }
              });
            },
            child: Container(
              width: sizeConfig.screenWidth * .2,
              height: sizeConfig.screenWidth * .2,
              decoration: BoxDecoration(
                  color: Color(0xFF417BFb),
                  borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: currentIcon == 0
                    ? ImageIcon(AssetImage('assets/rec.png'),
                        color: Colors.white, size: fontWidgetSize.icone + 10)
                    : Image.asset('assets/stop.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget animationReco() {
    return SpinKitDoubleBounce(
      color: Color(0xFF417BFb),
      size: sizeConfig.screenWidth * .92,
    );
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });
      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }
        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;

      save(result);

      //todo Date and Time
    });
  }


  void save(result) async
  {
    int hour;
    int day;
    int minute;
    int month;

    await  showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(data: ThemeData.light(), child: child,);
      },
    ).then((selectedDate) {
      month= selectedDate.month-DateTime.now().month;
      day =  selectedDate.day-DateTime.now().day+(month*30);
    });
    await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    ).then((selectedTime) async {
      hour = selectedTime.hour-DateTime.now().hour;
      minute = selectedTime.minute-DateTime.now().minute;
    });
    String s = DateFormat.yMMMd().format(DateTime.now());
      int id = await RegisterDatabaseProvider.db.insertRegister(new RecordModel(pathRec: result.path,));
      print("day $day");
      print("minute $minute");
      print("hour $hour");
      print("month $month");
      _localNotification.showNotificationAfter(day,hour,minute,id,"record title","record body", result.path);
     Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return RecorderPlayer(result.path);
    }));

  }
}
