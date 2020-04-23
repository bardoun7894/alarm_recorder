import 'dart:convert';
import 'dart:typed_data';
import 'package:alarm_recorder/databases/RegisterDatabase.dart';
import 'package:alarm_recorder/model/recordModel.dart';
import 'package:flutter/material.dart'; 
import '../app_localizations.dart';
import '../main.dart';
import '../recorder/recorder_player.dart';

String base64String(Uint8List data){
  return base64Encode(data);
}
Image imageFromBase64String(String base64String,double height,double width){
return Image.memory(base64Decode(base64String),fit: BoxFit.fill,height:height,width: width,);
}

//this for save records to sqlite also for push notification
void saveRecord(String result,context,String nameRecord) async {
  int hour;
  int day;
  int minute;
  int month;
  LocalNotification _localNotification = LocalNotification();
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
  int id = await RegisterDatabaseProvider.db.insertRegister(new RecordModel(pathRec: result,name: nameRecord));
  //push notification
  _localNotification.showNotificationAfter(day,hour,minute,id,"","record",nameRecord, "$result");
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
    return  RecorderPlayer(result);
  }));
}
Future<bool> ShowCoupons(context,result,String nameRecord ) {

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
                        color: Color(0xFF417BFb),),
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
                              image: AssetImage('assets/clo.png'),
                            ),
                            borderRadius: BorderRadius.circular(45.0),
//                            border: Border.all(
//                                color: Colors.white,
//                                style: BorderStyle.solid,
//                                width: 2.0)
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
                    AppLocalizations.of(context).translate("dialog_save_data"),
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
                          saveRecord(result,context,nameRecord);

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

