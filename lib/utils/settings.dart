import 'package:alarm_recorder/Translate/app_localizations.dart';
import 'package:alarm_recorder/Translate/change_language.dart';
import 'package:flutter/material.dart';

class MySettings extends StatefulWidget {
  @override
  _MySettingsState createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("settings"),style:TextStyle(color: Colors.grey,)),
        leading: InkWell(onTap: ()=>Navigator.pop(context),child: Icon(Icons.arrow_back,color: Colors.grey,)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {return ChangeLanguage();}));
                },
                leading: Icon(Icons.language,color: Colors.blueAccent,),
                title: Text(AppLocalizations.of(context).translate("change_language"),style: TextStyle(color: Colors.grey)),
                trailing:Icon(Icons.arrow_forward,color: Colors.grey,) ,
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.notifications,color: Colors.blueAccent,),

                title: Text(AppLocalizations.of(context).translate("notifications"),style: TextStyle(color: Colors.grey),),
                trailing:Icon(Icons.arrow_forward,color: Colors.grey,) ,
              ),
            ),
           Card(
              child: ListTile(
                leading: Icon(Icons.monetization_on,color: Colors.blueAccent,),
                title: Text(AppLocalizations.of(context).translate("disable_ads"),style: TextStyle(color: Colors.grey),),
                trailing:Icon(Icons.arrow_forward,color: Colors.grey,) ,
              ),
            ),

            Card(
              child: ListTile(
                leading: Icon(Icons.info_outline,color: Colors.blueAccent,),
                title: Text(AppLocalizations.of(context).translate("about"),style: TextStyle(color: Colors.grey)),
                trailing:Icon(Icons.arrow_forward,color: Colors.grey,) ,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
