import 'package:alarm_recorder/interfaces/database_model.dart';

class Note implements DataBaseModel{
int id;
String title;
String description;
String date;
String time;
Note({this.id,this.title,this.description,this.date,this.time});


  @override
  toMap() {
    return{
      'id':this.id,
      'title':this.title,
      'description':this.description,
      'date':this.date,
      'time':this.time,
    };
  }

  @override
  fromMap(Map<String,dynamic > map) {
    // TODO: implement fromMap
    return new Note(
        id:map['id'],
        title:map['title'],
        description:  map['description'],
        date: map['date'],
        time:  map['time']);
  }




}