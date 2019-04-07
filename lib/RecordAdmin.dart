import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'myData.dart';
import 'Record_Page.dart';
import 'globals.dart';
import 'event_info_page.dart';

class RecordAdmin extends StatefulWidget {
  static String tag = 'RecordAdmin';
  @override
  State<StatefulWidget> createState() {
    return _RecordAdminState();
  }
}

class _RecordAdminState extends State<RecordAdmin> {

  List<myData> allData = [];
  var participantsList = new List<String>();
  var participantsIDsList = new List<String>();
  static String eventName;
  DateTime eventStartingDate = new DateTime(1960), eventFinishingDate = new DateTime(1960), eventStartingTime = new DateTime(0,0,0,0,0), eventFinishingTime = new DateTime(0,0,0,0,0);
  var occur = new List<bool>(7);
  var recordTable = new List<String>();


  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Events').once().then((DataSnapshot snap) {
      var data = snap.value;



      eventName=data[eventIndex]['Event Name'];
      eventStartingDate= new DateTime.fromMillisecondsSinceEpoch(data[eventIndex]['Starting Date']);
      eventFinishingDate= new DateTime.fromMillisecondsSinceEpoch(data[eventIndex]['Finishing Date']);
      eventStartingTime= new DateTime.fromMillisecondsSinceEpoch(data[eventIndex]['Starting Time']);
      eventFinishingTime= new DateTime.fromMillisecondsSinceEpoch(data[eventIndex]['Finishing Time']);
      occur[0]=data[eventIndex]['Occur'][0];
      occur[1]=data[eventIndex]['Occur'][1];
      occur[2]=data[eventIndex]['Occur'][2];
      occur[3]=data[eventIndex]['Occur'][3];
      occur[4]=data[eventIndex]['Occur'][4];
      occur[5]=data[eventIndex]['Occur'][5];
      occur[6]=data[eventIndex]['Occur'][6];

      //CODE TO ADD the participants Email and A's under each occurrence(RECORD TABLE) of this event
      DateTime tempDate = eventStartingDate;
      String s;
      int j=0;
      recordTable.clear();
      while(tempDate.isBefore(eventFinishingDate.add(Duration(days:1))) && j < 1){
        if(occur[tempDate.weekday-1]) {
          s = "${tempDate.day}-${tempDate.month}-${tempDate.year}";
          ref.child('Events').child(eventIndex).child("Record Table").child(s).once().then((DataSnapshot snap){
          Map<dynamic, dynamic> map = snap.value;
          var keys = map.entries;
          var values = map.values;
          keys.forEach((k) {
            Map<dynamic, dynamic> map1 = k.value;
            var UserFields = map1.entries;
            var UserValues = map1.values;
            UserFields.forEach((i) {
              participantsIDsList.add(k.key);
              participantsList.add(i.key);
              print(
                  "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
              print(k.key);
              print(i.key);
            }); //internal loop
          });
        });
          j++;
        }
        tempDate=tempDate.add(Duration(days:1));
      }

      setState(() {
      });
    });

  }



  @override
  Widget build(BuildContext context) {
    final newTextTheme = Theme.of(context).textTheme.apply(
      bodyColor: Colors.green,
      displayColor: Colors.green,
    );
    final iconTheme = new IconThemeData(
        color: Colors.green);
    return Scaffold(
      appBar: AppBar(
        title: Text('Record'),
        textTheme: newTextTheme,
        backgroundColor: Colors.white,
        iconTheme: iconTheme,
      ),
      body: new Container(

          child: new ListView.builder(
            itemCount: participantsList.length,
            itemBuilder: (_, index) {
              return UI(index);
            },
          )
      ),
    );
  }

  Widget UI(var index) {

    if(participantsList[index] != null){
      return new Card(
                  child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new FlatButton(
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${participantsList[index]}\n',
                                      style: TextStyle(color: Colors.black, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                builder: (context) => RecordPage(participantsIDsList[index]),
                                ));
                                },
                            ),

                          ],
                        ));
    }
  }
}