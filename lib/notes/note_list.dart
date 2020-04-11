
import 'package:alarm_recorder/model/Note.dart';
import 'package:alarm_recorder/notes/textFieldCustom.dart';
import 'package:alarm_recorder/theme/myTheme.dart';
import 'package:alarm_recorder/databases/NoteDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NoteList extends StatefulWidget {
  NoteList({Key key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  Widget cont = Container(
    width: 10,
    height: 10,
  );
  bool isSelected = false;
  @override
  void didUpdateWidget(NoteList oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<List<Note>>(
          future: NoteDatabaseProvider.db.getAllNotes(),
          builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
            switch(snapshot.connectionState){

              case ConnectionState.none:
                return Center(
                  //todo picture no list note
                  child: CircularProgressIndicator(),
                );
                break;

              case ConnectionState.waiting:
                return Center(
                  //todo picture no list note
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active:
                return Center(
                  //todo picture no list note
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.done:
                return getNoteList(snapshot.data);
                break;
            }
            return getNoteList(snapshot.data);

          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MyTextFieldCustom(false)));
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

  Widget getNoteList(List<Note> notelist) {
    return new StaggeredGridView.countBuilder(
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
                      note: note,
                    )));
          },
          child: new Card(
              color: index.isEven ? Colors.yellow[100] : Colors.blue[300],
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        note.title,
                        style: TextStyle(
                            color:
                                index.isEven ? Colors.blueGrey : Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      note.description,
                      style: TextStyle(
                          color: index.isEven ? Colors.grey : Colors.white),
                      textAlign: TextAlign.center,
                      textWidthBasis: TextWidthBasis.parent,
                    ),
                  ),
                  Positioned(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              note.date,
                              style: TextStyle(
                                  color: index.isEven
                                      ? Colors.grey
                                      : Colors.white),
                            ),
                            isSelected ? Icon(Icons.delete) : cont
                          ],
                        ),
                      ),
                      bottom: 10,
                      left: 10)
                ],
              )),
        );
      },
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2.5 : 2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
