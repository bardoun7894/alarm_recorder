import 'package:alarm_recorder/model/Note.dart';
import 'package:alarm_recorder/notes/note_list.dart';
import 'package:alarm_recorder/utils/database.dart';
import 'package:alarm_recorder/utils/dateTimePicker.dart';
import 'package:alarm_recorder/utils/screen_size.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyTextFieldCustom extends StatefulWidget {
  Note note ;
  String title;
  MyTextFieldCustom(this.note,this.title);
  @override
  _MyTextFieldCustomState createState() => _MyTextFieldCustomState(this.note,this.title);
}
class _MyTextFieldCustomState extends State<MyTextFieldCustom> {
  DbProvider db =DbProvider();
  Note note ;

  WidgetSize fontWidgetSize;
  SizeConfig sizeConfig;
  String title;
  TextEditingController descriptionController =TextEditingController();
  _MyTextFieldCustomState(this.note,this.title);
  bool cursor =true;
  DateTime firstDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    sizeConfig = SizeConfig(context);
    fontWidgetSize = WidgetSize(sizeConfig);
    TextStyle _textStyle = Theme.of(context).textTheme.body1;
    // descriptionController.text=note.description;
    return Scaffold(

      body: Stack(

        children: <Widget>[

          Container(

          margin:EdgeInsets.only(top: sizeConfig.screenHeight*.045) ,
            height: sizeConfig.screenHeight*.1,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween
                  , children: <Widget>[
                  Icon(Icons.arrow_back_ios,
                      color:Color(0xFF417BFb),
                      size:fontWidgetSize.icone),
                  InkWell(
                      onTap: (){
                        save();
                        dateRange(context);
                      },
                      child: Icon(Icons.save,color:Color(0xFF417BFb),size:fontWidgetSize.icone,)),
                ],),
                Row(
                  children: <Widget>[
                    SizedBox(height:sizeConfig.screenHeight*.017,),
                    Text(
                      "${formatDateTime()}",
                      style: TextStyle(fontSize:fontWidgetSize.bodyFontSize-5,
                          color: Colors.black45),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
           padding: EdgeInsets.only(top:sizeConfig.screenHeight*.1,
               right: sizeConfig.screenWidth*.01,
               left: sizeConfig.screenWidth*.01,
               bottom: sizeConfig.screenHeight*.005),
            child: TextField(

              maxLengthEnforced: true,
               readOnly: cursor,
               onTap: (){
                setState(() {
                  cursor=false;
                });

               },
               controller: descriptionController,
              cursorColor: Colors.amber,
              cursorRadius: Radius.circular(2),
              cursorWidth: 1,

             autofocus: false,
               style: _textStyle,
              onChanged: (String value) {
                 updateDescription();
              //   debugPrint('Current value: $value');
             },

             maxLines:100,
//              maxLength: 99999,
            keyboardType: TextInputType.multiline,

            ),
          ),
        ],
      ),
    );
  }

  String formatDateTime(){
    String firstD = DateFormat("MM MMMM  HH:mm" ).format(firstDate).toString()+" PM";
    return firstD;
  }
  void updateDescription(){
    note.description=descriptionController.text;
  }

  void save() {
   // note.date=DateFormat.yMMMd().format(DateTime.now());
// var firstNote= Note(0,"mohamed","this is me trying to connect","12/04/2020","34:90 PM");
//  db.insertNote(firstNote);


  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog=AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_)=>alertDialog
    );

  }

  void moveToLastScreen() {

//    Navigator.of(context)
//        .push(MaterialPageRoute(builder: (context) {
//      return NoteList();
//    }));
  }
}
