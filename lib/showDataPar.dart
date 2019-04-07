import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'myData.dart';
import 'event_info_page.dart';
import 'dart:developer';
import 'globals.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'login.dart';
import 'package:geocoder/geocoder.dart';




class ParticipantEventPage extends StatefulWidget {

  @override
  _ParticipantEventPageState createState() => _ParticipantEventPageState();
}

class _ParticipantEventPageState extends State<ParticipantEventPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<eventData> allData = [];
  var id ;



  var AdminID1;
  var UserEvenIndex = [] ;
  List<String> IDs ;
  @override
  void initState() {



    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var currentUser = ref.child('Users').child(globalUserId).child('Event_Ids');



    currentUser.once().then((DataSnapshot snap){
      allData.clear();
      Map<dynamic,dynamic> map = snap.value ;
      var keys = map.entries ;
      print("###################################################");

      keys.forEach((k) {

        ref.child('Events').once().then((DataSnapshot snap) {
          var data = snap.value;

          print(currentEventIDs);
          print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
          print(data[k.value]['Starting Date']);
          eventData d = new eventData(
            data[k.value]['Event Name'],
            data[k.value]['Starting Date'],
            data[k.value]['Finishing Date'],
            data[k.value]['Starting Time'],
            data[k.value]['Finishing Time'],
            data[k.value]['Accessability'],
            AdminID1= data[k.value]['AdminID'],
            data[k.value]['Location Name'],
            data[k.value]['Occur'],
            k.value,
            data[k.value]['Lat'],
            data[k.value]['Lng'],
          );
          print(AdminID1);
          if(globalUserId!=AdminID1){


            allData.add(d);}
          print("###################################################");

          setState(() {
            print('Length : ${allData.length}');
          });


        });

      });
    });



  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,



      drawer: new Drawer(

          child: new ListView(

            children: <Widget>[
              SizedBox(height: 20.0),
              new UserAccountsDrawerHeader(

                decoration: new BoxDecoration(
                  // color: Color(0xFF18D191)
                ),

                accountName: new Text('$currentUserName',style: TextStyle(fontSize: 25.0, color: Colors.black),),
                accountEmail: new Text("smahmood@gmail.com",style: TextStyle(color: Colors.black54),),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: new Text("SM",style: TextStyle(color: Colors.black) ,),
                ),
              ),

              new ListTile(
                title: new Text("Time off request"),
                trailing: new Icon(Icons.email),

              ),
              new ListTile(
                title: new Text("Leave request"),
                trailing: new Icon(Icons.message),
              ),
              new Divider(),
              new ListTile(
                title: new Text("Sign out"),
                trailing: new Icon(Icons.exit_to_app),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
                },
              ),
            ],
          )
      ),










      body: new Container(





          child: allData.length == 0
              ? new Text("")
              : new ListView.builder(
            itemCount: allData.length,
            itemBuilder: (_, index) {

              return UI(
                  allData[index].EventName, allData[index].StartingDate, allData[index].FinishingDate, allData[index].StartingTime, allData[index].FinishingTime ,allData[index].Accessability,
                  allData[index].EventID,allData[index].AdminID,allData[index].LocationName, allData[index].lat, allData[index].lon
              );
            },
          )
      ),
    );
  }

  _CheckType (bool Accessability ){
    if(Accessability==true) {
      return true;
    }

    return false ;


  }

  Widget UI(var name, var StartingDate, var FinishingDate, var StartingTime,
      var FinishingTime, var Accessability, var j , var eventAdmin , var LocationName, var lat, var lon) {
    var sDate = new DateTime.fromMillisecondsSinceEpoch(StartingDate);
    var fDate = new DateTime.fromMillisecondsSinceEpoch(FinishingDate);
    var sTime = new TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(StartingTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(StartingTime).minute).format(context);
    var fTime = new TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(FinishingTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(FinishingTime).minute).format(context);


    print("${sDate.year}#############################################");
    return new Card(

      elevation: 10.0, // SHADOW
      color: Colors.transparent,
      child: new Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16.0, right: 4.0),
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  Expanded(
                      child: Text("'$LocationName'",
                          style: const TextStyle(
                              color: Colors.white))),
                  Row(
                    children: [

                      IconButton(
                        icon: Icon(
                            Icons.share
                            ,
                            color: Colors.white),

                      ),
                    ],
                  )
                ],
              ),
            ),
            new FlatButton(


              onPressed: () {
                eventIndex=j;
                Event_Admin=eventAdmin;
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => EventInfoPage(j, name, sDate, fDate, DateTime.fromMillisecondsSinceEpoch(StartingTime),
                      DateTime.fromMillisecondsSinceEpoch(FinishingTime), Accessability, lat, lon),
                ));              },

              padding: EdgeInsets.fromLTRB(10,0,80,0),
              child: Column( // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Text('$name' ,style: const TextStyle(
                      color: Colors.white, fontSize: 25),textAlign: TextAlign.start),

                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: Text("${sDate.day}/${sDate.month}/${sDate.year} - ${fDate.day}/${fDate.month}/${fDate.year}\n $sTime - $fTime",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16)),

            ),

          ],

        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
              image: NetworkImage('https://www.lauraashley.com/ccsto'
                  're/v1/images/?source=/file/v7727088434283220431/products/3726007.alt1.jpg&height=475&width=475'),
              colorFilter: const ColorFilter.mode(
                  Colors.black26, BlendMode.hardLight),
              fit: BoxFit.cover
          ),
        ),

      ),// CARD COLOR

    );



//      elevation: 10.0, // SHADOW
//      color: Color(0xFF18D191), // CARD COLOR
//      child: new Container(
//        padding: const EdgeInsets.only(
//          top: 8.0,
//          bottom: 8.0,
//          left: 5.0,
//        ),
//        child: new Row(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          mainAxisAlignment: MainAxisAlignment.spaceAround,
//          children: <Widget>[
//            new Container(
//                width: 60.0,
//                height: 60.0,
//                decoration: new BoxDecoration(
//                    shape: BoxShape.circle,
//                    image: new DecorationImage(
//                        //fit: BoxFit.fill,
//                        image: new NetworkImage(
//                            "https://upload.wikimedia.org/wikipedia/en/thumb/9/98/King_Fahd_University_of"
//                                "_Petroleum_%26_Minerals_Logo.svg/1200px-King_Fahd_Unive"
//                                "rsity_of_Petroleum_%26_Minerals_Logo.svg.png")
//                    )
//                )),
//            new FlatButton(
//              child: RichText(
//                text: TextSpan(
//                  style: Theme.of(context).textTheme.title,
//                  children: <TextSpan>[
//                    TextSpan(
//                      text: '$name\n',
//                      style: TextStyle(color: Colors.white, fontSize: 20),
//                    ),
//                    TextSpan(
//                      text: '${sDate.day}/${sDate.month}/${sDate.year} - ${fDate.day}/${fDate.month}/${fDate.year}\n',
//                      style: TextStyle(color: Colors.black, fontSize: 15),
//                    ),
//                    TextSpan(
//                      text: '$sTime - $fTime',
//                      style: TextStyle(color: Colors.black, fontSize: 15),
//                    ),
//
//                  ],
//                ),
//              ),
//              onPressed: () {
//          eventIndex=j;
//          Event_Admin=eventAdmin;
//          Navigator.of(context).pushNamed(EventInfoPage.tag);
//              },
//            ),
//            new Center(
//                child: _CheckType(Accessability) == true ? new Icon(Icons.add_circle) : new Icon(Icons.do_not_disturb_on)
//            )
//
//          ],
//        ),
//      ),
//    );
  }


}