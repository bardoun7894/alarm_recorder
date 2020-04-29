
import 'package:alarm_recorder/app_localizations.dart';
import 'package:alarm_recorder/home_page/homepage.dart';
import 'package:alarm_recorder/model/Note.dart';
import 'package:alarm_recorder/notes/add_note.dart';
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

  List<int> _selectedIndexList = List();
  bool _selectionMode = false;
   List<Note> _noteList = List();  
 void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
    _selectedIndexList.clear();
    }
  }
 Future<bool> _onBackPressed() {
          return Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
          return MyHomePage();
        }));
  }
  @override
  Widget build(BuildContext context) {
    sizeConfig = SizeConfig(context);
    fontWidgetSize = WidgetSize(sizeConfig);
    List<Widget> _buttons = List();
    if (_selectionMode) {
      _buttons.add(IconButton(
        icon: Icon(Icons.delete,color:Colors.blueAccent,),
       onPressed: () {
         for(int i =0;i<_selectedIndexList.length;i++){
        print(_selectedIndexList[i]);
               NoteDatabaseProvider.db.deleteNoteWithId(_noteList[i].id) ;
                  }
       Navigator.of(context).pushReplacement(MaterialPageRoute(
                 builder: (BuildContext context) {
                  return NoteList();
                 }));  
          _selectedIndexList.sort();
           print('Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
          }));
    }
        return WillPopScope(
            child: Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.blueAccent,), onPressed: () {
                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return MyHomePage();
                              }));
              },),
              elevation: 0,
              backgroundColor: Colors.grey[200],

             actions: _buttons,
      ),
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
                            Text(AppLocalizations.of(context).translate('note_not_found'),style: TextStyle(color: Colors.grey),)
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(
     builder: (BuildContext context) => AddNotes(false,false,false)));
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: mainTheme.primaryColorDark,
      ),
    ), onWillPop:_onBackPressed,
        );
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
    
          _noteList=notelist;
          Note note = notelist[index];
          
          if(_selectionMode){
         return  makemultiSelection(note,index);
          }else{
          return showNoteContainer(note,index);
          }
        
        },
        staggeredTileBuilder: (int index) =>
        
     new StaggeredTile.count(2, notelist[index].imagePath ==""? 1.5 : 2),
     
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }

 
  Widget showNoteContainer(Note note,int index){

      return  InkWell(
        onLongPress: (){
          setState(() {
              _changeSelection(enable: true, index: index);
          });
        },
          onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => AddNotes( true,  false,false, note: note )));
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
                              note.imagePath =="" ? Padding(padding: EdgeInsets.only(top:sizeConfig.screenHeight*.04),child: Text(note.description.length > 17
                                  ? note.description.substring(0, 17)
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
                             note.date,  style: TextStyle(
                                      color:  Colors.grey
                                        ),
                                ),
                               cont
                              ],
                            ),
                          ),
                          bottom: 10,
                          left: 10)
                    ],
                  )),
            ),
          );
       
  }

 Widget  makemultiSelection(Note note,int index){
      return  InkWell(
        onLongPress: (){
          setState(() {
             _changeSelection(enable: false,index: -1);
        
          });
             },
        onTap: () { 
                setState(() {
                if(_selectedIndexList.contains(index)){
                  _selectedIndexList.remove(index);
                } else {
                  _selectedIndexList.add(index);
                }
              });
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
                              note.imagePath =="" ? Padding(padding: EdgeInsets.only(top:sizeConfig.screenHeight*.04),child: Text(note.description.length > 17
                                  ? note.description.substring(0, 17)
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
                             note.date,  style: TextStyle(
                                      color:  Colors.grey
                                        ),
                                ),
                               Padding(
                                 padding: const EdgeInsets.only(left: 10),
                                 child: Icon(
               _selectedIndexList.contains(index) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                 color: _selectedIndexList.contains(index) ? Colors.blueAccent : Colors.blueAccent,
                        ),
                               ),
                              ],
                            ),
                          ),
                          bottom: 10,
                          left: 10)
                    ],
                  )),
            ),
          );
       
  }



}
