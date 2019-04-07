


import 'package:flutter/material.dart';


import 'login.dart';
import 'home_widget.dart';
import 'event_info_page.dart';
import 'Record_Page.dart';
import 'RecordAdmin.dart';
import 'globals.dart';
import 'View_Account.dart';
import 'ModifyEvent.dart';

Color hexToColor(int rgb) => new Color(0xFF000000 + rgb);

void main() {
  runApp(
    new MaterialApp(
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: hexToColor(0x18D191),
        splashColor: Colors.black,
        textSelectionColor:Colors.black,

      ),
      home: new MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    Home.tag: (context) =>  Home(),
    EventInfoPage.tag: (context) => EventInfoPage(eventIndex, eventName, eventStartingDate, eventFinishingDate,
        eventStartingTime, eventFinishingTime, eventAccessability, lat, lon),
    RecordPage.tag: (context) => RecordPage(id),
    RecordAdmin.tag: (context) => RecordAdmin(),
    MyHomePage.tag: (context) => MyHomePage(),
    //ModifyEvent.tag : (context) => ModifyEvent(),
  };


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      home: LoginPage(),
      routes: routes,
    );
  }
}