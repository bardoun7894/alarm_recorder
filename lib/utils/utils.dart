import 'package:alarm_recorder/utils/dateTimePicker.dart';
import 'package:flutter/material.dart';





Future<bool> ShowCoupons(context,doIt,int i ) {

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
                    "You want to Save Record",
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
                             i=0;
                             doIt();

                        },
                        color: Colors.teal,
                        child: Center(
                          child: Text(
                            "yes",
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
                                "No",
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

