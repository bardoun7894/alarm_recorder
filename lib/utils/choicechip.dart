 
import 'package:alarm_recorder/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../app_localizations.dart';

class myChoice extends StatefulWidget {
  String result;
  String nameRecord;
  String note;
int id;
bool edit ;
String descriptionControllertext;
String imgString;
myChoice({this.result, this.nameRecord,this.id,this.edit,this.descriptionControllertext,this.imgString,this.note});

  @override
  _myChoiceState createState() => _myChoiceState();
}

class _myChoiceState extends State<myChoice> {
  var data = [' حفظ مع تذكير ', 'حفظ بدون تذكير'];
  var icons = [Icons.access_alarm, Icons.timer_off];

  shared(_value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_value == 0) {
      prefs.setString("select", "remember");
    }
    if (_value == 1) {
      prefs.setString("select", "notRemember");
    } else {
      prefs.setString("select", "nothing");
    }
  }

  bool boolV = false;
  int _value = 1;
  @override
  Widget build(BuildContext context) {
    return dialog(widget.result, context, widget.nameRecord);
  }

   Widget dialog(String result, context, nameRecord) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 350.0,
        width: 200.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
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
                    color: Color(0xFF417BFb),
                  ),
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
              child: Text( _value ==null?"": AppLocalizations.of(context).translate("dialog_save_data"),
                style: TextStyle(
                    color: Color(0xFF417BFb),
                     fontWeight: FontWeight.w600,
                    fontSize: 18.0),
              ),
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
            _value ==null?Container(): FlatButton(
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
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
               _value ==null?Container():  FlatButton(
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
  }
}
