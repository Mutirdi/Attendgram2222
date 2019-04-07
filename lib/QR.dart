import 'package:flutter/material.dart';
import 'Record_Page.dart';
import 'globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'myData.dart';
import 'search_page.dart';
import 'ModifyEvent.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QR extends StatefulWidget {
  static String tag = 'qr-code-page';
  var eventNum = eventIndex;
  var code;

  QR(var c){
    code = c;
  }

  @override
  State<StatefulWidget> createState() {
    return QRpage(code);
  }
}

class QRpage extends State<QR> {
  var code ;
  QRpage(var c){
    code = c ;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        title: new Text('QR Page',style: new TextStyle(
        fontSize: 25.0,
        color: Color(0xFF18D191) )),

        centerTitle: true,

        backgroundColor:Colors.transparent,
        elevation: 0.0,
        iconTheme: new IconThemeData(color: Color(0xFF18D191)),
        ),

        backgroundColor: Colors.white,
        body:Center(
          child:
          new QrImage(
            data: code ,
            size: 300.0,
          ),
        ),

    );




  }
}