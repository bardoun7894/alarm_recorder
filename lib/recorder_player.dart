import 'package:alarm_recorder/utils/screen_size.dart';
import 'package:flutter/material.dart';

class RecorderPlayer extends StatefulWidget {
  @override
  _RecorderPlayerState createState() => _RecorderPlayerState();
}

class _RecorderPlayerState extends State<RecorderPlayer> {
  int _selectedIndex;
  bool isSelected=false ;
Widget cont =Container(width: 10,height: 10,);

  WidgetSize fontWidgetSize;
  SizeConfig sizeConfig;

  @override
  Widget build(BuildContext context) {
    sizeConfig = SizeConfig(context);
    fontWidgetSize = WidgetSize(sizeConfig);
    return MaterialApp(
      home: Scaffold(
       backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          color: Colors.white10,
          child: Stack(
            children: <Widget>[
             Padding(
               padding:   EdgeInsets.only(top: sizeConfig.screenHeight*.04),
               child: Container(
                 height:sizeConfig.screenHeight*.72,
                 child: ListView.builder(
                   itemCount: 8,
                   itemBuilder: (BuildContext context,index){
                   return  Padding(
                     padding:   EdgeInsets.only(
                         right: sizeConfig.screenWidth*.05,
                         left: sizeConfig.screenWidth*.05),
                     child: Card(
                       child: ListTile(
                         selected:   isSelected,
                         onTap: (){
                       setState(() {   });

                         },
                         onLongPress: (){
                 toggleSelection();

                         },

                       leading: Icon(Icons.music_note,color: Colors.blueAccent,),
                         title: Text("2019/2020.mp3"),
                         trailing: cont,
                         ),
                     ),
                   );

                   },
                 ),
               ),
             ),
                      _player()



            ],
          ),
        ),
      ),
    );
  }
  void toggleSelection() {
    setState(() {
      if (isSelected) {
        cont=Container(width: 10,height: 10,);
        isSelected = false;
      } else {
        cont=Icon(Icons.check_box,color: Colors.blueAccent,);
        isSelected = true;
      }
    });
  }


  Widget _player()

  {


    return  Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: sizeConfig.screenHeight*.205,
      child: Container(
        padding: EdgeInsets.only(top:5),
        color: Colors.blueAccent,
        child: Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: (){},
                    iconSize: fontWidgetSize.icone+5,
                    icon: Icon(Icons.skip_previous),
                    color: Colors.white,
                    focusColor: Colors.pinkAccent,
                  ),
                  IconButton(
                    onPressed: (){},
                    iconSize: fontWidgetSize.icone+15,
                    icon: Icon(Icons.pause_circle_filled),
                    color: Colors.white,
                    focusColor: Colors.pinkAccent,
                  ),
                  IconButton(
                  onPressed: (){},
                  color: Colors.white,
                 iconSize: fontWidgetSize.icone+5,
                   icon:Icon(Icons.skip_next)),

                ],
              ),
            Slider(
              onChanged: (double value){

              },
             activeColor: Colors.white,
              value: .6,
            )
          ],
        ),
      ),
    );
  }
}
