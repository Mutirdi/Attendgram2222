import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'myData.dart';
import 'event_info_page.dart';
import 'dart:developer';
import 'globals.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'login.dart';
import 'showDataAdmine.dart';
import 'showDataPar.dart';
import 'package:location/location.dart';



class ShowDataPage extends StatefulWidget {

  @override
  _ShowDataPageState createState() => _ShowDataPageState();
}

class _ShowDataPageState extends State<ShowDataPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<eventData> allData = [];
  var id ;
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
            data[k.value]['AdminID'],
            data[k.value]['Location Name'],
            data[k.value]['Occur'],
            k.value,
            data[k.value]['Lat'],
            data[k.value]['Lng'],

          );
          getUserLocation();
          allData.add(d);
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
      appBar: new AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.menu,color: Color(0xFF18D191)),
                iconSize: 25.0

            );
          },
        ),
        bottom: new TabBar(
          tabs: <Tab>[
            new Tab(
              icon: const Icon(Icons.people,color:Color(0xFF808080)),

            ),
            new Tab(

              icon: new Icon(Icons.person,color:Color(0xFF808080)),
            ),
          ],
          controller: _tabController,

        ),

        title: new Text('Home',style: new TextStyle(
            fontSize: 25.0,
            color: Colors.green )),
        centerTitle: true,
        backgroundColor:Colors.white,
        elevation: 0.0,

      ),


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

      body: new TabBarView(
        children: <Widget>[
          new ParticipantEventPage(),
          new AdminEventPage(),

        ],
        controller: _tabController,
      ),
    );
  }

  _CheckType (bool Accessability ){
    if(Accessability==true) {
      return true;
    }

    return false ;


  }

  Widget UI(var name, var StartingDate, var FinishingDate, var StartingTime, var FinishingTime, var Accessability, var j , var eventAdmin) {
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
                      child: Text("Building 22",
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text("$name",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 25)),
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
              image: NetworkImage('https://cdn.dribbble.com/users/1240533/screenshots/4917377/copper_photo_industry_04_800x600.jpg'),
              colorFilter: const ColorFilter.mode(
                  Colors.black26, BlendMode.hardLight),
              fit: BoxFit.cover
          ),
        ),

      ),// CARD COLOR

    );

  }


  Future<void> getUserLocation() async{

    var location = new Location();

    try {
      currentLocation = await location.getLocation();
    } catch(PlatformException) {
      currentLocation = null;
    }
  }
}