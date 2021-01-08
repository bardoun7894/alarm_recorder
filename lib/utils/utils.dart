import 'dart:convert';
import 'dart:typed_data';
 
import 'package:alarm_recorder/Translate/app_localizations.dart';
import 'package:alarm_recorder/databases/NoteDatabase.dart';
import 'package:alarm_recorder/databases/RegisterDatabase.dart';
import 'package:alarm_recorder/home_page/homepage.dart';
import 'package:alarm_recorder/model/Note.dart';
import 'package:alarm_recorder/model/recordModel.dart';
import 'package:alarm_recorder/notes/note_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';
 
import '../main.dart';
import '../recorder/recorder_player.dart';
import 'dialogNoteRec.dart';

LocalNotification  _localNotification = LocalNotification() ;
bool isTimeSet=false;
Color backgroundColor=Colors.grey[100] ;
Color fColor ;

String base64String(Uint8List data){
  return base64Encode(data);
}
Image imageFromBase64String(String base64String,double height,double width){
return Image.memory(base64Decode(base64String),fit:BoxFit.fill,height:height,width: width,);
}
//this for save records to sqlite also for push notification
reminderDateTime(id,imageString,title,description,payload,context)async{
  int hour=0;
  int day=0;
  int minute=0;
  int month=DateTime.now().month;
  await showDatePicker(

    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2018),
    lastDate: DateTime(2030),
    builder: (BuildContext context, Widget child) { return Theme(
        data: ThemeData.light(), 
        child: child,
      ); },
  ).then( 
    (selectedDate) async{
    month = selectedDate.month - DateTime.now().month;
    day = selectedDate.day - DateTime.now().day + (month * 30);
    await showTimePicker(
    initialTime: TimeOfDay.now(),
    context: context,
     ).then((selectedTime) async {
    hour = selectedTime.hour - DateTime.now().hour;
    minute = selectedTime.minute - DateTime.now().minute;
  });

  });
  _localNotification.showNotificationAfter(day,hour,minute,id,imageString,title,description,payload);
 if(title=="record"){
   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
    return  RecorderPlayer(payload);
  }));
 }
 if(payload=="note"){
   showRichAlertDialog(context);
   await Future.delayed(Duration(seconds: 3));
   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){  return MyHomePage();}));
 }

}
Future<bool> saveNoteDialog(int id,bool edit ,String descriptionControllertext,String imgString,context)async {
  String note="note";
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) { 
      return MyChoice(id:id,edit: edit,descriptionControllertext: descriptionControllertext,imgString: imgString,note:note);
            });
}
Future<bool> showRichAlertDialog(context)async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return RichAlertDialog(
          //uses the custom alert dialog
          alertTitle: richTitle(AppLocalizations.of(context).translate("note")),
          alertSubtitle: richSubtitle(AppLocalizations.of(context).translate("saved_succesfully")),
          alertType: RichAlertType.SUCCESS,alertButtonText: AppLocalizations.of(context).translate("cancel"),
        );
      }
  );
}
Future<bool> saveRecordDialog(context,String result,String nameRecord )async {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return MyChoice(result:result,nameRecord:nameRecord);
      });
}


void saveRecord(String payload,context,String nameRecord) async {
  int id = await RegisterDatabaseProvider.db.insertRegister(new RecordModel(pathRec: payload , name: nameRecord));
  reminderDateTime( id,"","record",nameRecord,payload,context);
}
void saveNote(int id,bool edit ,String descriptionControllertext,String imgString,context) async {
    String titleData = descriptionControllertext.length > 12
        ? descriptionControllertext.substring(0, 12)
        : descriptionControllertext;
    String descriptionData = descriptionControllertext;
    String s = DateFormat.yMMMd().format(DateTime.now());
    if (edit == true) {
      NoteDatabaseProvider.db.updateNote(new Note(
          id: id,
          imagePath: imgString,
          title: titleData,
          description: descriptionData,
          date:s,
          ));
      reminderDateTime( id,imgString,titleData,descriptionData,"note",context);
    
    } else if (edit == false) {
      int ids = await NoteDatabaseProvider.db.insertNote(new Note(
          imagePath: imgString,
          title: titleData,
          description: descriptionData,
          date: s,
          ));
        reminderDateTime(ids,imgString,titleData,descriptionData,"note",context);
  
     }
   
  }





