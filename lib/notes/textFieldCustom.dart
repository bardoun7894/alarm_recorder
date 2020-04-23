import 'package:alarm_recorder/model/Note.dart';
import 'package:alarm_recorder/databases/NoteDatabase.dart';
import 'package:alarm_recorder/notes/note_list.dart';
import 'package:alarm_recorder/utils/getlocation.dart';
import 'package:alarm_recorder/utils/screen_size.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alarm_recorder/utils/utils.dart';

import '../main.dart';

class MyTextFieldCustom extends StatefulWidget {
  final Note note;
  String title;
  final bool edit;
  bool camera;
  bool location;

  MyTextFieldCustom(this.edit, this.camera, this.location, {this.note})
      : assert(edit != null || note == null);
  @override
  _MyTextFieldCustomState createState() =>
      _MyTextFieldCustomState(this.note, this.title);
}

class _MyTextFieldCustomState extends State<MyTextFieldCustom> {
  GetLocation getLocation = GetLocation();
  String textAfterGetImage = "";
  File _image;
  bool fabClicked = false;
  String imgString = "";
  LocalNotification _localNotification = LocalNotification();
  Note note;
  List<Note> list = [];
  WidgetSize fontWidgetSize;
  SizeConfig sizeConfig;
  String title;
  TextEditingController descriptionController = TextEditingController();

  _MyTextFieldCustomState(this.note, this.title);

  bool cursor = true;
  DateTime firstDate = DateTime.now().add(Duration(minutes: 1));

  @override
  void initState() {
    super.initState();
    if (widget.edit == true) {
      if (widget.note.description != null) {
        descriptionController.text = widget.note.description;
      }

      imgString = widget.note.imagePath;
    }
  }

  Widget imageFr(String image) {
    return imageFromBase64String(
        image, sizeConfig.screenHeight * .13, sizeConfig.screenWidth * .50);
  }

  Future getImage(source) async {
    var image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      var compressedImage = await FlutterImageCompress.compressAndGetFile(
        croppedFile.path,
        image.path,
        quality: 50,
      );
      setState(() {
        _image = compressedImage;
        if (_image != null) {
          imgString = base64String(_image.readAsBytesSync());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig = SizeConfig(context);
    fontWidgetSize = WidgetSize(sizeConfig);
    TextStyle _textStyle = Theme.of(context).textTheme.body1;
    // descriptionController.text=note.description;

    return Scaffold(
      floatingActionButton: widget.location == true
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  fabClicked = true;
                  getLocation.getPermissionStatus(context);
                });
              },
              backgroundColor: Colors.blueAccent,
              child: Icon(
               Icons.gps_fixed,
              color: Colors.white,
                size: 30,
                 ),
            )
          : Container(),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: sizeConfig.screenHeight * .03),
            height: sizeConfig.screenHeight * .13,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        List<Note> p =
                            await NoteDatabaseProvider.db.getAllNotes();
                        List<Note> ss = p;
                        print(ss);
                      },
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios,
                            color: Color(0xFF417BFb),
                            size: fontWidgetSize.icone - 5),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: saveButton()),
                        InkWell(
                            onTap: () {
                              //      save();
//                        dateRange(context);
                              textAfterGetImage = descriptionController.text;
                              widget.camera == true
                                  ? getImage(ImageSource.camera)
                                  : getImage(ImageSource.gallery);

                              descriptionController.text = textAfterGetImage;
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: Icon(
                                widget.camera == true
                                    ? Icons.camera_enhance
                                    : Icons.image,
                                color: Color(0xFF417BFb),
                                size: fontWidgetSize.icone - 3,
                              ),
                            )),
                      ],
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: sizeConfig.screenHeight * .06,
                    ),
                    Text(
                      "${formatDateTime()}",
                      style: TextStyle(
                          fontSize: fontWidgetSize.bodyFontSize - 13,
                          color: Colors.black45),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: sizeConfig.screenHeight * .1,
                right: sizeConfig.screenWidth * .01,
                left: sizeConfig.screenWidth * .01,
                bottom: sizeConfig.screenHeight * .005),
            child: ListView(
              children: <Widget>[
                imgString == ""
                    ? Container()
                    : imageFromBase64String(imgString, 300, 300),
                TextFormField(
                  maxLengthEnforced: true,
                  readOnly: cursor,
                  onTap: () {
                    setState(() {
                      cursor = false;
                    });
                  },

                  controller: descriptionController,
                  cursorColor: Colors.amber,
                  cursorRadius: Radius.circular(2),
                  cursorWidth: 1,
                  autofocus: false,
                  style: _textStyle,

                  onChanged: (String value) {
//               updateDescription();
                    //   debugPrint('Current value: $value');
                  },

                  maxLines: 100,
//              maxLength: 99999,
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatDateTime() {
    String firstD =
        DateFormat("MM MMMM  HH:mm").format(firstDate).toString() + " PM";
    return firstD;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void saveNote() async {
    int hour;
    int day;
    int minute;
    int month;
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    ).then((selectedDate) {
      month = selectedDate.month - DateTime.now().month;
      day = selectedDate.day - DateTime.now().day + (month * 30);
    });
    await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    ).then((selectedTime) async {
      hour = selectedTime.hour - DateTime.now().hour;
      minute = selectedTime.minute - DateTime.now().minute;
    });
    String titleData = descriptionController.text.length > 12
        ? descriptionController.text.substring(0, 12)
        : descriptionController.text;
    String descriptionData = descriptionController.text;
    String s = DateFormat.yMMMd().format(DateTime.now());
    if (widget.edit == true) {
      NoteDatabaseProvider.db.updateNote(new Note(
          id: widget.note.id,
          imagePath: imgString,
          title: titleData,
          description: descriptionData,
          date: s,
          time: firstDate.hour.toString()));

      _localNotification.showNotificationAfter(day, hour, minute,
          widget.note.id, imgString, titleData, descriptionData, "note");
      Navigator.pop(context);
    } else if (widget.edit == false) {
      int id = await NoteDatabaseProvider.db.insertNote(new Note(
          imagePath: imgString,
          title: titleData,
          description: descriptionData,
          date: s,
          time: firstDate.hour.toString()));
      print("day $day");
      print("minute $minute");
      print("hour $hour");
      print("month $month");
      _localNotification.showNotificationAfter(
          day, hour, minute, id, imgString, titleData, descriptionData, "note");
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return NoteList();
      }));
    }
  }

  saveLocationNote() async {
    String titleData = descriptionController.text.length > 12
        ? descriptionController.text.substring(0, 12)
        : descriptionController.text;
    String descriptionData = descriptionController.text;
    String s = DateFormat.yMMMd().format(DateTime.now());
    if (widget.edit == true) {
      NoteDatabaseProvider.db.updateNote(new Note(
          id: widget.note.id,
          imagePath: imgString,
          title: titleData,
          description: descriptionData,
          date: s,
          time: firstDate.hour.toString()));
      getLocation.getLastPosition(widget.note.id, titleData, descriptionData,
          "location $titleData", _localNotification);
      Navigator.pop(context);
    } else if (widget.edit == false) {
      int id = await NoteDatabaseProvider.db.insertNote(new Note(
          imagePath: imgString,
          title: titleData,
          description: descriptionData,
          date: s,
          time: firstDate.hour.toString()));
      getLocation.getLastPosition(id, titleData, descriptionData,
          "location $titleData", _localNotification);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return NoteList();
      }));
    }
  }

  Widget saveButton() {
    return widget.location == true
        ? fabClicked == true
            ? InkWell(
                onTap: () {
                  saveLocationNote();
                },
                child: Icon(Icons.save,
                    color: Color(0xFF417BFb), size: fontWidgetSize.icone - 3))
            : Container()
        : InkWell(
            onTap: () {
              saveNote();
//                        dateRange(context);
            },
            child: Icon(Icons.save,
                color: Color(0xFF417BFb), size: fontWidgetSize.icone - 3));
  }
}
