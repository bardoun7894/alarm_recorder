import 'dart:io';

import 'package:alarm_recorder/model/Note.dart';
import 'package:alarm_recorder/notes/textFieldCustom.dart';
import 'package:alarm_recorder/theme/myTheme.dart';
import 'package:alarm_recorder/utils/screen_size.dart';
import 'package:alarm_recorder/utils/utils.dart';
import 'package:alarm_recorder/databases/NoteDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NoteList extends StatefulWidget {

  NoteList(  {Key key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  WidgetSize fontWidgetSize;
  SizeConfig sizeConfig;
  List<Note> lisnote=[];
  Widget cont = Container();
  bool isSelected = false;
  @override
  void didUpdateWidget(NoteList oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig = SizeConfig(context);
    fontWidgetSize = WidgetSize(sizeConfig);
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: FutureBuilder<List<Note>>(

          future: NoteDatabaseProvider.db.getAllNotes(),
          builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          if(snapshot.hasData){
            if(snapshot.data.length==0){
              return Container(
                  child: Padding(
                    padding:  EdgeInsets.only(top:sizeConfig.screenHeight*.5),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                         Icon(Icons.note,color: Colors.blueAccent,size: 30,),
                          SizedBox(height: 20,),
                          Text("you don't insert any note ...",style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                    ),
                  ),
              );
            }else{
              return getNoteList(snapshot.data);
              }
              }

          else{
               return Container(
                 width: sizeConfig.screenWidth,
                height: sizeConfig.screenHeight,
                color: Colors.white,
               );
            }

          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MyTextFieldCustom(false,false)));
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: mainTheme.primaryColorDark,
      ),
    );
  }

  void toggleSelection() {
    setState(() {
      if (isSelected) {
        cont = Container(
          width: 10,
          height: 10,
        );
        isSelected = false;
      } else {
        cont = Icon(
          Icons.check_box,
          color: Colors.blueAccent,
        );
        isSelected = true;
      }
    });
  }

  Widget imageFr(String image) {
    return imageFromBase64String(
        image, sizeConfig.screenHeight * .13, sizeConfig.screenWidth * .50);
  }

  Widget getNoteList(List<Note> notelist) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: new StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: notelist.length,
        itemBuilder: (BuildContext context, int index) {

          Note note = notelist[index];
          return InkWell(
            onLongPress: () {
              setState(() {
                isSelected = true;
              });
            },
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyTextFieldCustom(
                        true,
                        false,
                        note: note,
                      )));
              print(note.imagePath);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: new Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: Colors.black
                    )],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          note.imagePath != null
                              ? ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                              child: note.imagePath ==""? Container():imageFr(note.imagePath))
                              : Container(),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              note.imagePath =="" ? Padding(padding: EdgeInsets.only(top:sizeConfig.screenHeight*.04),child: Text(note.description.length > 20
                                  ? note.description.substring(0, 20)
                                  :note.description,style: TextStyle( color: Colors.blueGrey,fontWeight: FontWeight.bold,),maxLines: 2)):Text(note.title,style: TextStyle( color: Colors.blueGrey,fontWeight: FontWeight.bold),)

                            ],
                          ),
                        ],
                      )
                  ,


                      Positioned(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  note.date,
                                  style: TextStyle(
                                      color:  Colors.grey
                                        ),
                                ),
                                isSelected ? Icon(Icons.delete) : cont
                              ],
                            ),
                          ),
                          bottom: 10,
                          left: 10)
                    ],
                  )),
            ),
          );
        },
        staggeredTileBuilder: (int index) =>
            new StaggeredTile.count(2, notelist[index].imagePath ==""? 1.5 : 2),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}
