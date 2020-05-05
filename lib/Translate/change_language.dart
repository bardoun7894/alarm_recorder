import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_localizations.dart';
import 'app_language.dart';
import 'package:alarm_recorder/home_page/homepage.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
       body: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate('settings'),
          style: TextStyle(fontSize: 32),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () async{
                appLanguage.changeLanguage(Locale("en"));
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                return MyHomePage();
                }));
              },
        child: Text('English'),
            ),
            RaisedButton(
              onPressed: () {
                appLanguage.changeLanguage(Locale("ar"));
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                 return MyHomePage();
                }));
              },
              child: Text('العربي'),
            )
          ],
        )
      ],
    ),
    ),
    );
  }
}
