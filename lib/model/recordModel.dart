import 'package:alarm_recorder/interfaces/database_model.dart';

class RecordModel implements DataBaseModel{

  int id ;
  String pathRec;
  String date;
  String time ;


  RecordModel({this.id, this.pathRec, this.date, this.time});



  @override
  fromMap(Map<String,dynamic > map) {
    return new RecordModel(
        id:map['id'],
        pathRec:  map['pathRec'],
        date: map['date'],
        time:  map['time']);
  }
  @override
  toMap() {
    return{
      'id':this.id,
      'pathRec':this.pathRec,
      'date':this.date,
      'time':this.time,
    };

  }

}