import 'package:alarm_recorder/model/Note.dart';
import 'package:alarm_recorder/model/note_inherited_widget.dart';
import 'package:alarm_recorder/notes/textFieldCustom.dart';
import 'package:alarm_recorder/theme/myTheme.dart';
import 'package:alarm_recorder/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  NoteList({Key key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  Note note;
  int count =0;
  FackNotes fackNotes=FackNotes();
DbProvider db =DbProvider();

  List<Note> noteList;

//  @override
//  void initState()   {
//    getDataList();
//    // TODO: implement initState
//    super.initState();
//  }

  getDataList() async{
  noteList= await db.notes();
  return noteList;
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
          body: Container(
         child: getNoteList(
         ),  ),
         floatingActionButton: FloatingActionButton(onPressed: (){
            navigateToDetails( note,'');
         },
           child: Icon(Icons.add,color: Colors.white),
           backgroundColor:mainTheme.primaryColorDark,
         ) ,
             );
           }
        
          Widget getNoteList() {
             return new StaggeredGridView.countBuilder(
               crossAxisCount: 4,
               itemCount:1,
               itemBuilder: (BuildContext context, int index) => new Card(
                   color:index.isEven?Colors.yellow[100]: Colors.blue[300],
                   child: Stack(
                      children: <Widget>[

                      InkWell(
                        onTap: (){

                          print(noteList[0].title);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Title",style: TextStyle(color: index.isEven?Colors.blueGrey:Colors.white,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),

                       Center(
                   child: Text("dd",style: TextStyle(color: index.isEven?Colors.grey:Colors.white),textAlign: TextAlign.center,textWidthBasis: TextWidthBasis.parent,),
                       ),
                         Positioned(child: Text("19/2/2019",style: TextStyle( color:index.isEven?Colors.grey:Colors.white),),bottom: 10,left:10)

                     ],
                   )),
               staggeredTileBuilder: (int index) =>
               new StaggeredTile.count(2, index.isEven ? 3 : 2),
               mainAxisSpacing: 4.0,
               crossAxisSpacing: 4.0,
             );
               }



  void _showSnackbar(BuildContext context, String message) {
final snackbar =SnackBar(content: Text(message));
   Scaffold.of(context).showSnackBar(snackbar);
  }


  void navigateToDetails(Note note,String title) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) {
      return MyTextFieldCustom(note,title);
    }));
  }


}
