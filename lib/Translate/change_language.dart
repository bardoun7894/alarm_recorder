import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_localizations.dart';
import 'app_language.dart';

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
                print('kkk');
                appLanguage.changeLanguage(Locale("en"));
              },
              child: Text('English'),
            ),
            RaisedButton(
              onPressed: () {
                appLanguage.changeLanguage(Locale("ar"));
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
