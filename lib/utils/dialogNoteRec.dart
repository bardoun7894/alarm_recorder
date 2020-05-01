 
import 'package:alarm_recorder/utils/screen_size.dart';
import 'package:alarm_recorder/utils/utils.dart';
import 'package:flutter/material.dart'; 
import '../Translate/app_localizations.dart';

class MyChoice extends StatefulWidget {
  final String result;
  final String nameRecord;
  final String note;
final int id;
final bool edit ;
final String descriptionControllertext;
final String imgString;
MyChoice({this.result, this.nameRecord,this.id,this.edit,this.descriptionControllertext,this.imgString,this.note});

  @override
  _MyChoiceState createState() => _MyChoiceState();
}


class _MyChoiceState extends State<MyChoice> {
  WidgetSize fontWidgetSize;
  SizeConfig sizeConfig;

  @override
  Widget build(BuildContext context) {
    sizeConfig = SizeConfig(context);
    fontWidgetSize = WidgetSize(sizeConfig);
    return dialog(widget.result, context, widget.nameRecord);
  }

   Widget dialog(String result, context, nameRecord) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height:sizeConfig.screenHeight*.40,
        width: sizeConfig.screenHeight*.4,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height:sizeConfig.screenHeight*.2,
                ),
                Container(
                  height:sizeConfig.screenHeight*.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    color: Color(0xFF417BFb),
                  ),
                ),
                Positioned(
                  top: sizeConfig.screenHeight*.08,
                  left: sizeConfig.screenWidth*.23,
                  child: Container(
                    height: 90.0,
                    width: 90.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(

                        fit: BoxFit.cover,
                        image: AssetImage('assets/clo.png'),
                      ),
                      borderRadius: BorderRadius.circular(45.0),
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
              child: Text( AppLocalizations.of(context).translate("dialog_save_data"),
                style: TextStyle(
                    color: Color(0xFF417BFb),
                     fontWeight: FontWeight.w600,
                    fontSize:fontWidgetSize.bodyFontSize-8),
              ),
            ),
            SizedBox(height: sizeConfig.screenHeight*.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
          FlatButton(
                  onPressed: () {
                  if(widget.note=="note"){
                   saveNote(widget.id,widget.edit,widget.descriptionControllertext,widget.imgString,context);
                      }else{
                     
                    saveRecord(result, context, nameRecord);
                     }
                     },
                  color: Colors.teal,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate("ok"),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:fontWidgetSize.bodyFontSize-8,
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
                          fontSize:fontWidgetSize.bodyFontSize-8,
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
  }
}
