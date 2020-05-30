import 'dart:math';

import 'package:alarm_recorder/Translate/app_localizations.dart';
import 'package:alarm_recorder/model/Note.dart';
import 'package:alarm_recorder/databases/NoteDatabase.dart';
import 'package:alarm_recorder/notes/note_list.dart';
import 'package:alarm_recorder/utils/getlocation.dart';
import 'package:alarm_recorder/utils/screen_size.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alarm_recorder/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class AddNotes extends StatefulWidget {
  final Note note;
  final bool edit;
  final bool camera;
  final bool location;

  AddNotes(this.edit, this.camera, this.location, {this.note})
      : assert(edit != null || note == null);
  @override
  _AddNotesState createState() => _AddNotesState(this.note);
}

class _AddNotesState extends State<AddNotes> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  GetLocation getLocation = GetLocation();
  String textAfterGetImage = "";
  File _image;
  bool isFabClicked=false ;

  bool isHideFAB = false ;
  bool isImageMapHide=false;
  bool isNormalNote=false;
  String imgString = "";
  LocalNotification _localNotification = LocalNotification();
  Note note; 
  List<Note> list = [];
  WidgetSize fontWidgetSize;
  SizeConfig sizeConfig; 
  TextEditingController meterController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool _validate = false;

  _AddNotesState(this.note);
  bool cursor = true;
  DateTime firstDate = DateTime.now().add(Duration(minutes: 1));
  @override
  void initState() {
    super.initState();

    if (widget.edit == true) {
      descriptionController.text = widget.note.description;
      imgString = widget.note.imagePath;
    }
    if (widget.camera == true) {
      getPermissionStatus();
    }
    if(widget.location){

        isImageMapHide=false;
        isNormalNote=false;
    }else{
      isHideFAB=true;
      isImageMapHide=true;
      isNormalNote=true;
    }
    setState(() {
      activateFab();
    });
  }

  @override
  void dispose() {
    super.dispose();
    getLocation.disposeFab();
    descriptionController.dispose();
    meterController.dispose();
  }

  Widget imageFr(String image) {
    return imageFromBase64String(
        image, sizeConfig.screenHeight * .13, sizeConfig.screenWidth * .50);
  }
  Future getImage(source) async {
    try{
      var image = await ImagePicker.pickImage(source: source);
      if (image != null) {
        File croppedFile = await ImageCropper.cropImage(
            sourcePath: image.path,
            compressQuality: 100,
            maxWidth: 480,
            maxHeight: 480,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: AppLocalizations.of(context).translate("cropper"),
                toolbarColor: Colors.blueAccent,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            ));
        setState(() {
          if (croppedFile != null) {
            _image = croppedFile;
            if (_image != null) {
              imgString = base64String(_image.readAsBytesSync());
            }
          } else {
            return;
          }
        });
      }
    }catch(e){}
print(e.toString());
  }
  putImageText() {
    textAfterGetImage = descriptionController.text;
    widget.camera == true
        ? getImage(ImageSource.camera)
        : getImage(ImageSource.gallery);
    descriptionController.text = textAfterGetImage;
  }
  requestPermission() async {
    await Permission.camera.request();
    await Permission.photos.request();

  }
  activateFab() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool fab = sharedPreferences.getBool("fabClicked");
    if (fab == true) {
      isFabClicked = true;
      print("fabClicked true");
     } else {
      isFabClicked = false;
      print("fabClicked false");
    }
  }
  getPermissionStatus() async {
    var status;
    if (widget.camera == true && widget.location==false) {
      status = await Permission.camera.status;
    }
    if (widget.camera == false) {
      status = await Permission.photos.status;
    }
    print("$status ll");
    switch (status) {
      case PermissionStatus.undetermined:
        requestPermission();
        putImageText();
        break;
      case PermissionStatus.granted:
        putImageText();
        break;
      case PermissionStatus.denied:
        requestPermission();
        putImageText();
        break;
      case PermissionStatus.restricted:
        requestPermission();
        putImageText();
        break;
      case PermissionStatus.permanentlyDenied:
        requestPermission();
        putImageText();
        break;
    }
  }


  saveDatainEditText(String image,String body)async{
    SharedPreferences sh=await SharedPreferences.getInstance();
    sh.setString("imageSh", image);
    sh.setString("bodySh",body);
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig = SizeConfig(context);
    fontWidgetSize = WidgetSize(sizeConfig);
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton:!isHideFAB 
              ? FloatingActionButton(
                onPressed: () async {
                  setState(() {
                    try {
                      isFabClicked=true;
                    //  getLocation.getPermissionStatus(context);
                      getLocation.getPermissionStatus(context);
                    } catch (e) {
                      print(e);
                    }
                  });
                },
                backgroundColor: isFabClicked ? Colors.blue : Colors.grey[500],
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
              padding: EdgeInsets.only(top: 10),
              height: sizeConfig.screenHeight * .16,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: sizeConfig.screenWidth * .02, left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              color: Color(0xFF417BFb),
                              size: fontWidgetSize.icone - 5),
                          onPressed: () {
                            _onBackPressed();
                          },
                        ),
                        isImageMapHide?Row(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: saveButton()),
                            Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: IconButton(
                                icon: Icon(
                                  widget.camera == true 
                                    
                                      ? Icons.camera_enhance
                                      : Icons.image,
                                  color: Color(0xFF417BFb),
                                  size: fontWidgetSize.icone - 3,
                                ),
                                onPressed: () {
                                  try {
                                    getPermissionStatus();
                                      } catch (e) {
                                    print("exception" + e);
                                      }
                                },
                              ),
                            ),
                          ],
                             ):Container()
                    
                      ],
                    )
                    ,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: sizeConfig.screenHeight * .1,
                  right: sizeConfig.screenWidth * .02,
                  left: sizeConfig.screenWidth * .02,
                  bottom: sizeConfig.screenHeight * .005),
             child:! isImageMapHide && widget.location ? locationStartButton(): ListView(
                children: <Widget>[
                  Text(
                    "  ${formatDateTime()} ",
                    style: TextStyle(
                        fontSize: fontWidgetSize.bodyFontSize - 13,
                        color: Colors.black45),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                    style: TextStyle(color: Colors.grey[700], fontSize: 16,fontWeight: FontWeight.bold),
                    maxLines: 100,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onWillPop: _onBackPressed,
    );
  }
  String formatDateTime() {
    String firstD = DateFormat("MM MMMM  HH:mm").format(firstDate).toString() + " PM";
    return firstD;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  saveLocationNote(double xmeter) async {

    String titleData = descriptionController.text.length > 12
        ? descriptionController.text.substring(0, 12)
        : descriptionController.text;
    String descriptionData = descriptionController.text;
    String s = DateFormat.yMMMd().format(DateTime.now());
    if (descriptionController.text == "") {
      _displaySnackBar(
          AppLocalizations.of(context).translate("text_description_empty"));
    } else {
      if (widget.edit == true) {

        NoteDatabaseProvider.db.updateNote(new Note(
            id: widget.note.id,
            imagePath: imgString,
            title: titleData,
            description: descriptionData,
            date: s,
            time: firstDate.hour.toString()));
        getLocation.getLastPosition(widget.note.id, titleData, descriptionData,
            imgString, "location", _localNotification, xmeter);
        Navigator.pop(context);
      } else if (widget.edit == false) {
        int id = await NoteDatabaseProvider.db.insertNote(
            new Note(
            imagePath: imgString,
            title: titleData,
            description: descriptionData,
            date: s,
            time: firstDate.hour.toString()
            )
        );
        getLocation.getLastPosition(id, titleData, descriptionData, imgString,"location $titleData", _localNotification, xmeter);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return NoteList();
        }));
      }
    }
  }
  
  bool islocationForFirst(){
   
   if( widget.location ){
      return true ;   
    }else{
        return false;
    }
     }

  Widget  locationStartButton() {
    return Container(
      child: Center(
          child: Column(
        children: <Widget>[
       Padding(
            child: Image.asset(
              "assets/locationMap.png",
              width: sizeConfig.screenWidth*.8 ,
              height: sizeConfig.screenHeight*.5,
            ),
            padding: EdgeInsets.only(top: sizeConfig.screenHeight * .1),
          ),
         Padding(
            child: Text(
              AppLocalizations.of(context).translate("welcome_location"),
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.bold,
              ),
            ),

            padding: EdgeInsets.only(top: sizeConfig.screenHeight * .001),
          ),

         Padding(
            padding: EdgeInsets.only(top: sizeConfig.screenHeight * .05),
            child:
            isFabClicked? Container(
                height: 35,
                width: 100,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue[300], Colors.blueAccent]),
                    borderRadius: BorderRadius.circular(20)),
                child:
             FlatButton(
                    child: Text(
                      AppLocalizations.of(context).translate("start_location"),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                       setState(() {
                        if(isFabClicked){
                        isHideFAB = true;
                        isImageMapHide=true;
                        _displaySnackBar(AppLocalizations.of(context).translate("snack_message"));
                        }
                        });
                   
                    })

            ):Container(),
          )

        ],
      )),
    );
  }

  Widget locationDialog() {
    
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Form(
              key: _formKey,
              child: Container(
                height: sizeConfig.screenHeight * .45,
                width: sizeConfig.screenHeight * .4,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: sizeConfig.screenHeight * .22,
                        ),
                        Container(
                          height: sizeConfig.screenHeight * .15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            color: Color(0xFF417BFb),
                          ),
                        ),
                        Positioned(
                          top: sizeConfig.screenHeight * .09,
                          left: sizeConfig.screenWidth * .25,
                          child: Container(
                            height: 90.0,
                            width: 90.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/noteSound.png'),
                              ),
                              borderRadius: BorderRadius.circular(45.0),
                            ),
                          ),
                        )
                      ],
                    ),
                    textMeterField(),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate("dialog_save_data"),
                        style: TextStyle(
                            color: Color(0xFF417BFb),
                            fontWeight: FontWeight.w600,
                            fontSize: fontWidgetSize.bodyFontSize - 8),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            setState(() {

                              double meter = double.parse(meterController?.text);


                            if (_formKey.currentState.validate()) {

                                 saveLocationNote(meter);


                              }
                            });
                          },
                          color: Colors.teal,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate("ok"),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontWidgetSize.bodyFontSize - 8,
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
                              AppLocalizations.of(context).translate("no"),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontWidgetSize.bodyFontSize - 8,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget textMeterField() {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: meterController,
            textInputAction: TextInputAction.done,
            style: TextStyle(
                fontFamily: 'sans sherif',
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontSize: fontWidgetSize.bodyFontSize - 5),
            onChanged: (value){

            },
            validator: (value) {
              if (value.isEmpty) {
                _validate = true;
                return AppLocalizations.of(context).translate("hint_distance_error");
              }
              if (double.parse(value)<100){
               return AppLocalizations.of(context).translate("hint_100_error");
              }
              return null;
            },
            decoration: InputDecoration(
              icon: Icon(
                Icons.location_on,
                color: Colors.blueAccent,
              ),
              hintMaxLines: 1,
              hintText: !_validate
                  ? AppLocalizations.of(context).translate("hint_distance")
                  : null,
              hintStyle: TextStyle(
                  fontFamily: 'sans sherif',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: fontWidgetSize.bodyFontSize - 10),
            ),
          ),
        ),
      ),
    );
  }

  _displaySnackBar(String text) {
    final snackBar = SnackBar(backgroundColor: Colors.blueAccent, content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget saveButton() {
    return widget.location == true ? InkWell(
                onTap : () { locationDialog(); },
                child :  Container(
                  width: 50,
                  height: 24,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: Colors.blueAccent,width: 3)
                  ),
                  child: Center(

                    child:   Text(AppLocalizations.of(context).translate("save"),style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 14),),
                  ),
                )
    ) : InkWell(
            onTap: () {
              if (descriptionController.text == "") {
                _displaySnackBar(AppLocalizations.of(context)
                    .translate("text_description_empty"));
              } else { if (widget.edit == true) {
                  saveNoteDialog(widget.note.id, widget.edit,
                      descriptionController.text, imgString, context);
                }else if (widget.edit == false) {
                  saveNoteDialog(0, widget.edit, descriptionController.text,
                      imgString, context);
                        }}
                  },
            child:Container(
              width: 50,
              height: 24,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: Colors.blueAccent,width: 3)
              ),
              child: Center(
                child:   Text(AppLocalizations.of(context).translate("save"),style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 14),),
              ),
            ));
           }

  Future<bool> _onBackPressed() async{
    String titleData = descriptionController.text.length > 12
        ? descriptionController.text.substring(0, 12)
        : descriptionController.text ;
    String descriptionData = descriptionController.text ;
    String s = DateFormat.yMMMd().format(DateTime.now());
    if (widget.edit == false) {
      await NoteDatabaseProvider.db.insertNote(
          new Note(
              imagePath: imgString,
              title: titleData,
              description: descriptionData,
              date: s,
              time: firstDate.hour.toString()
          )
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return NoteList();
      }));
    }
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (BuildContext context) {
      return NoteList();
    }));
   return false;
  }
}
