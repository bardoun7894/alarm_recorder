import 'dart:async';
import 'dart:math';
 
import 'package:alarm_recorder/recorder_player.dart';
import 'package:alarm_recorder/theme/myTheme.dart';
import 'package:alarm_recorder/utils/screen_size.dart';
import 'package:alarm_recorder/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
 
class RecorderScreen extends StatefulWidget {
  @override
  _RecorderScreenState createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  int currentIcon=0;
  double transaction=0;
  double height;
  double width;

  WidgetSize fontWidgetSize;
  SizeConfig sizeConfig;

  @override
  Widget build(BuildContext context) {
    sizeConfig = SizeConfig(context);
    fontWidgetSize = WidgetSize(sizeConfig);

    return Scaffold(
      body: Container(
        color: Colors.white,
        width:sizeConfig.screenWidth,
        height:sizeConfig.screenHeight,
        child: Stack(

  children: <Widget>[


      Container(
        width: sizeConfig.screenWidth,
        height: sizeConfig.screenHeight*0.48,
        decoration: BoxDecoration(
            color: Color(0xFF417BFb),
            borderRadius: BorderRadius.only(
                bottomLeft:Radius.circular(sizeConfig.screenWidth*.2),
                bottomRight: Radius.circular(sizeConfig.screenWidth*.2))
        ),
        child: Column(
          children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top:sizeConfig.screenHeight*.05,
                left:sizeConfig.screenWidth*.02,
                right: sizeConfig.screenWidth*.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                 GestureDetector(
                   onTap: (){
                     Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                       return RecorderPlayer();
                     }));
                   },

                   child: Icon(Icons.list,color: Colors.white,size:fontWidgetSize.icone,)),
                Icon(Icons.settings,color: Colors.white,size:fontWidgetSize.icone,),

              ],  ), ),
               Padding(
                 padding:  EdgeInsets.only(top:sizeConfig.screenHeight*.12),
                 child: Column(
                  children: <Widget>[
                    Text('Voice 1',style: TextStyle(fontFamily: 'sans sherif',fontWeight: FontWeight.normal,color: Colors.white,fontSize:fontWidgetSize.titleFontSize),),
                  SizedBox(height: sizeConfig.screenHeight*.05,),
                  Text('00 : 25 : 05',style: TextStyle(fontFamily: 'sans sherif',fontWeight: FontWeight.normal,color: Colors.white,fontSize:fontWidgetSize.titleFontSize+10),),

    ],
              ),
               ),
        ],),
           ),

        Positioned(
            bottom:sizeConfig.screenHeight*-0.1,
            left: sizeConfig.screenWidth*(1/20),
            child: reco()),
        ]
        ),
      ),
    );
  }

reco(){


    return Stack(
      alignment: Alignment.center, 
     children: <Widget>[
     Center(
       child: currentIcon==0 ?Container(

         color:Colors.white,
         width:   sizeConfig.screenWidth*.92,
         height:   sizeConfig.screenWidth*.92,):animationReco(),

     )   ,

       Center(
         child: InkWell(
           onTap: (){
             setState(() {
               if(currentIcon==0){
                 currentIcon=1;
               }else{
                 currentIcon=0;
                 ShowCoupons(context);
               }
             });
           },

           child: Container(
             width: sizeConfig.screenWidth*.2,
             height: sizeConfig.screenWidth*.2,
             decoration: BoxDecoration(
                 color: Color(0xFF417BFb),
                 borderRadius: BorderRadius.circular(50)
             ),
             child: Center(
               child:currentIcon==0?ImageIcon(AssetImage('assets/rec.png'),
                 color:Colors.white,
                 size: fontWidgetSize.icone+10 ):Image.asset('assets/stop.png') ,
             ),
           ),
         ),
       ),
     ],

  );
  
}
Widget animationReco(){
  return  SpinKitDoubleBounce(
    color : Color(0xFF417BFb),
    size:  sizeConfig.screenWidth*.92,);
     
}

}
