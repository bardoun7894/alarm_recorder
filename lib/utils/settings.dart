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
        title: Text("Settings",style:TextStyle(color: Colors.black,)),
        leading: InkWell(onTap: ()=>Navigator.pop(context),child: Icon(Icons.arrow_back,color: Colors.black,)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: Icon(Icons.notifications,color: Colors.blueAccent,),
                title: Text("notification"),
                trailing:Icon(Icons.arrow_forward,color: Colors.grey,) ,
              ),

            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.language,color: Colors.blueAccent,),
                title: Text("change Language"),
                trailing:Icon(Icons.arrow_forward,color: Colors.grey,) ,
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.info_outline,color: Colors.blueAccent,),
                title: Text("about"),
                trailing:Icon(Icons.arrow_forward,color: Colors.grey,) ,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
