import 'package:alarm_recorder/interfaces/database_model.dart';

class Note implements DataBaseModel{
int _id;
String _title;
String _description;
String _date;
String _time;

Note(this._id,this._title,this._description,this._date,this._time);
Note.withId(this._id,this._title,this._description,this._date,this._time);

int get id=>_id;
String get title{
  return _title;
}
String get description=>_description;
String get date=>_date;
String get time=>_time;

  set title(String newTitle){

      this._title=newTitle;
  }
  set description(String newDescription){
    this._description=newDescription;
  }
   set date(String newDate){
    this._date=newDate;
  }
 set time(String newTime){

    this._time=newTime;
  }

  @override
  fromMap(Map<String, dynamic> map) {
    this._id=map['id'];
    this._title= map['title'] ;
    this._description=map['description'] ;
    this._date=map['date'];
    this._time=map['time'];
  }

  @override
  toMap() {
    return{
      'id':this._id,
      'title':this._title,
      'description':this._description,
      'date':this._date,
      'time':this._time,
    };
  }



}