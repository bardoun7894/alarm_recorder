import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future dateRange(context) async {
  DateTime firstDate = DateTime.now();
  DateTime lastDate = (DateTime.now()).add(new Duration(days: 7));

 

  final List<DateTime> picked = await DateRagePicker.showDatePicker(
      context: context,
      initialFirstDate: firstDate,
      initialLastDate: lastDate,
      firstDate: new DateTime(firstDate.year - 50),
      lastDate: new DateTime(firstDate.year + 50));
  if (picked != null && picked.length == 2) {
    firstDate = picked[0];
    lastDate = picked[1];
    String firstD = DateFormat("MM/dd/yyyy").format(firstDate).toString();
    String lastD = DateFormat("MM/dd/yyyy").format(lastDate).toString();

    print(firstD + "     " + lastD);
    _selectTime(context);
  }
}
Future<Null> _selectTime(context)async{

 TimeOfDay _time = new TimeOfDay.now();
    final TimeOfDay picked=await showTimePicker
    (context: context,
     initialTime: _time,
  ); 
   if (picked != null && picked != _time) {
    _time=picked;
    print(_time.toString());
  }
}
