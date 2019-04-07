
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'globals.dart';

Future<void> userCall() async {
  final DatabaseReference ref = FirebaseDatabase.instance.reference();
  ref.child('Users').child(globalUserId).once().then((DataSnapshot snap) {

    Map<dynamic,dynamic> map = snap.value ;
    currentUserName = map['Name'];
    currentUserDescripition = map['descrption'];
    currentUserinterests = map['interests'];
    currentEventAdmin = map['Event_Admin'];
    currentEventIDs = map['Event_Ids'] ;

  });
}


