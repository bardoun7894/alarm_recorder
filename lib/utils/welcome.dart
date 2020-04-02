import 'dart:async';

import 'package:alarm_recorder/model/welcomeModel.dart';
import 'package:alarm_recorder/recorder.dart';
import 'package:alarm_recorder/theme/myTheme.dart';
import 'package:flutter/material.dart'; 
import 'screen_size.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  WidgetSize fontWidgetSize;
  SizeConfig sizeConfig;
  String NextText = "Next";
  bool imInLastPage = false;
  int currentPosition = 1;
  List<WelcomeModel> welecomes = [
    WelcomeModel("assets/welcome.png", "Download , call, go ",
        "Praesent tellus mauris, tincidunt nec ipsum id, faucibus pellentesque leo. Nunc congue ac tellus quis porttitor. "),
    WelcomeModel("assets/welcome.png", " Wssalni App",
        "Praesent tellus mauris, tincidunt nec ipsum id, faucibus pellentesque leo. Nunc congue ac tellus quis porttitor. "),
    WelcomeModel("assets/welcome.png", "Wssalni App",
        "Praesent tellus mauris, tincidunt nec ipsum id, faucibus pellentesque leo. Nunc congue ac tellus quis porttitor. "),
    WelcomeModel("assets/welcome.png", "Wssalni App",
        "Praesent tellus mauris, tincidunt nec ipsum id, faucibus pellentesque leo. Nunc congue ac tellus quis porttitor. "),
  ];
  PageController _pageController;

  double transitionFactor = 1;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController = PageController(initialPage: 0, viewportFraction: 0.7);
    Timer(Duration(microseconds: 1), () {
        _pageController.nextPage(
            duration: Duration(microseconds:1), curve: Curves.fastOutSlowIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig = SizeConfig(context);
    fontWidgetSize = WidgetSize(sizeConfig);
    double offSet = sizeConfig.screenHeight * 0.19;
    double raduis = sizeConfig.screenWidth * 0.09;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _slider(context),
          Transform.translate(
            child: Align(
              alignment: Alignment.center,
              child: _pageIndicators(context, currentPosition),
            ),
            offset: Offset(0, offSet),
          ),
          _bottomNavigation(context, raduis),
        ],
      ),
    );
  }

  Widget _bottomNavigation(BuildContext context, double raduis) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
            color: mainTheme.primaryColorLight,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(raduis),
                topLeft: Radius.circular(raduis))),
        height: sizeConfig.screenHeight * 0.115,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text(
                "Skip",
                style: TextStyle(
                    fontSize: fontWidgetSize.bodyFontSize,
                    color: Color(0xFF636363)),
              ),
              onPressed: () async {
                // SharedPreferences pref = await SharedPreferences.getInstance();
                // pref.setBool("seen", true);
                _goToHomePage(context);
                //TODO SKIP
              },
            ),
            Padding(
              padding: EdgeInsets.only(right: 25),
              child: MaterialButton(
                minWidth: 140,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(raduis))),
                elevation: 0,
                color: mainTheme.primaryColorDark,
                child: Text(
                  NextText,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  //TODO go next Slide

                  if (imInLastPage) {
                    _goToHomePage(context);
                  } else {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
          padding: EdgeInsets.only(top: sizeConfig.screenHeight * 0.11),
          child: PageView.builder(
              itemCount: this.welecomes.length,
              controller: _pageController,
              onPageChanged: (position) {
                setState(() {
                  //       print(position);
                  currentPosition = position;
                });
                if (position == welecomes.length - 1) {
                  setState(() {
                    imInLastPage = true;
                    NextText = "Get Started";
                  });
                } else {
                  setState(() {
                    imInLastPage = false;
                    NextText = "Next";
                  });
                }
              },
              itemBuilder: (context, position) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: sizeConfig.screenHeight * 0.012,
                      right: sizeConfig.screenWidth * 0.02,
                      left: sizeConfig.screenWidth * 0.02),
                  child: Column(
                    children: <Widget>[
                      AnimatedBuilder(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: _imageNavigator(position, 1),
                        ),
                        builder: (BuildContext context, Widget child) {
                          if (_pageController.position.haveDimensions) {
                            transitionFactor = _pageController.page - position;
                            transitionFactor =
                                (1 - transitionFactor.abs() * 0.1)
                                    .clamp(0.0, 1.0);
                            return _imageNavigator(position, transitionFactor);
                          } else {
                            return _imageNavigator(position, 1);
                          }
                        },
                        animation: _pageController,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      AnimatedBuilder(
                        child: _columnText(position),
                        animation: _pageController,
                        builder: (BuildContext context, Widget child) {
                          if (_pageController.position.haveDimensions) {
                            transitionFactor = _pageController.page - position;
                            transitionFactor =
                                (1 - transitionFactor.abs()).clamp(0.0, 1.0);
                            return textAnimation(position, transitionFactor);
                          } else {
                            return textAnimation(position, 1.0);
                          }
                        },
                      ),
                    ],
                  ),
                );
              })),
    );
  }

  Widget indicatorPage(color, double margin) {
    return Container(
      width: 15,
      height: 5,
      margin: EdgeInsets.only(right: margin),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _pageIndicators(BuildContext context, position) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _newPageIndicator());
  }

  List<Widget> _newPageIndicator() {
    List<Widget> _widgets = [];
    for (int i = 0; i < welecomes.length; i++) {
      _widgets.add(indicatorPage(
          currentPosition == i ? Color(0xFFEFBC06) : Color(0xFFEFDC99),
          i == welecomes.length - 1 ? 0 : 12));
    }
    return _widgets;
    // indicatorPage(Colors.yellow, 16.0),
    // indicatorPage(Colors.yellow, 16.0),
    // indicatorPage(Colors.red, 0),
  }

  Widget textAnimation(position, transactionFactor) {
    return AnimatedOpacity(
      child: _columnText(position),
      duration: Duration(milliseconds: 300),
      opacity: transactionFactor,
    );
  }

  Column _columnText(position) {
    return Column(children: <Widget>[
      Text(welecomes[position].title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title.copyWith(
              color: Color(0xFF636363),
              fontSize: fontWidgetSize.titleFontSize)),
      SizedBox(
        height: 5,
      ),
      Text(
        welecomes[position].body,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subhead.copyWith(
            color: Color(0xFF636363), fontSize: fontWidgetSize.bodyFontSize),
      )
    ]);
  }

  void _goToHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return RecorderScreen();
    }));
  }

  Widget _imageNavigator(position, trans) {
    return ClipRRect(
      borderRadius: new BorderRadius.circular(20.0),
      child: Image(
      
        height: (sizeConfig.screenHeight * 0.55) * trans,
        fit: BoxFit.cover,
        image: AssetImage(
          welecomes[position].image,
        ),
      ),
    );
  }
}
