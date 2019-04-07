import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'myData.dart';
import 'event_info_page.dart';
import 'dart:developer';
import 'globals.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'login.dart';


//Our MyApp class. Represents our application
class SearchPage extends StatefulWidget {
  @override
  _SearchListExampleState createState() => new _SearchListExampleState();
}

class _SearchListExampleState extends State<SearchPage> {
  Widget appBarTitle = new Text(
    "Discover",
    style: new TextStyle(fontSize: 25.0,color: Colors.black),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Color(0xFF18D191),
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchview = new TextEditingController();
  List<eventData> AllEventsData;
  List<eventData> _filterList;
  bool _isSearching;
  String _searchText = "";


  _SearchListExampleState() {
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchview.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    inti();

  }

  inti(){

    AllEventsData = new List<eventData>();
    _filterList = new List<eventData>();
    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var Events = ref.child('Events');



    Events.once().then((DataSnapshot snap){
      AllEventsData.clear();
      Map<dynamic,dynamic> map = snap.value ;
      var keys = map.entries ;
      var data = map.values;


      keys.forEach((k) {
        print("###################################################");
        print(k);
        print("###################################################");

        if(map[k.key]['Accessability']==true){
          eventData d = new eventData(
            map[k.key]['Event Name'],
            map[k.key]['Starting Date'],
            map[k.key]['Finishing Date'],
            map[k.key]['Starting Time'],
            map[k.key]['Finishing Time'],
            map[k.key]['Accessability'],
            map[k.key]['AdminID'],
            map[k.key]['Location Name'],
            map[k.key]['Occur'],
            k.key,
              map[k.key]['Lat'],
              map[k.key]['Lng']
          );
          AllEventsData.add(d);
        }
      });

    });
    _handleSearchStart();


  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: globalKey,
      resizeToAvoidBottomPadding : false,// ignore home widget scafold,
      appBar: buildAppBar(context),
      body: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Flexible(
                child: _filterList.isNotEmpty || _searchview.text.isNotEmpty
                    ? new ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filterList.length,
                  itemBuilder: (_, index) {
                    return UI(
                      _filterList[index].EventName, _filterList[index].StartingDate, _filterList[index].FinishingDate, _filterList[index].StartingTime, _filterList[index].FinishingTime ,_filterList[index].Accessability,
                      _filterList[index].EventID,_filterList[index].AdminID,
                    );
                  },
                )
                    : new ListView.builder(
                  shrinkWrap: true,

                  itemCount: AllEventsData.length,
                  itemBuilder: (_, index) {
                    return UI(
                      AllEventsData[index].EventName, AllEventsData[index].StartingDate, AllEventsData[index].FinishingDate, AllEventsData[index].StartingTime, AllEventsData[index].FinishingTime ,AllEventsData[index].Accessability,
                      AllEventsData[index].EventID,AllEventsData[index].AdminID,
                    );
                  },
                )),
          ],
        ),
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
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.menu,color: Color(0xFF18D191)),
                iconSize: 25.0

            );
          },
        ),
        centerTitle: true,
        backgroundColor:Colors.transparent,
        elevation: 0.0,
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(
              icon: icon,
              onPressed: () {
                setState(() {
                  if (this.icon.icon == Icons.search) {
                    this.icon = new Icon(
                      Icons.close,
                      color: Colors.red,
                    );
                    this.appBarTitle = new TextField(
                      controller: _searchview,
                      style: new TextStyle(
                        color: Color(0xFF18D191),
                      ),
                      decoration: new InputDecoration(
                          prefixIcon: new Icon(Icons.search, color: Colors.black),
                          hintText: "Search...",
                          hintStyle: new TextStyle(color: Colors.black)),
                      onChanged: searchOperation,
                    );
                    _handleSearchStart();
                  } else {
                    _handleSearchEnd();
                  }
                });
              },
              iconSize: 25.0
          ),
        ]
    );


  }



  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Color(0xFF18D191),
      );
      this.appBarTitle = new Text(
        "Event Search ",
        style: new TextStyle(fontSize: 25.0,color: Colors.black),
      );
      _isSearching = false;
      _searchview.clear();
    });
  }

  void searchOperation(String searchText) {
    _filterList.clear();
    if (_isSearching != null) {
      for (int i = 0; i < AllEventsData.length; i++) {
        String data = AllEventsData[i].EventName.toString();
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          _filterList.add(AllEventsData[i]);
        }
      }
    }
  }


  Widget UI(var name, var StartingDate, var FinishingDate, var StartingTime, var FinishingTime, var Accessability, var j , var eventAdmin) {
    var sDate = new DateTime.fromMillisecondsSinceEpoch(StartingDate);
    var fDate = new DateTime.fromMillisecondsSinceEpoch(FinishingDate);
    var sTime = new TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(StartingTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(StartingTime).minute).format(context);
    var fTime = new TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(FinishingTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(FinishingTime).minute).format(context);

    print("${sDate.year}#############################################");
    return new Card(
      elevation: 10.0, // SHADOW
      color: Color(0xFF18D191), // CARD COLOR
      child: new Container(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: 5.0,
        ),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Container(
                width: 60.0,
                height: 60.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/en/thumb/9/98/King_Fahd_University_of"
                                "_Petroleum_%26_Minerals_Logo.svg/1200px-King_Fahd_Unive"
                                "rsity_of_Petroleum_%26_Minerals_Logo.svg.png")
                    )
                )),
            new FlatButton(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.title,
                  children: <TextSpan>[
                    TextSpan(
                      text: '$name\n',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    TextSpan(
                      text: '${sDate.day}/${sDate.month}/${sDate.year} - ${fDate.day}/${fDate.month}/${fDate.year}\n',
                      style: TextStyle(color: Colors.black54.withOpacity(0.8), fontSize: 15),
                    ),
                    TextSpan(
                      text: '$sTime - $fTime',
                      style: TextStyle(color: Colors.black54.withOpacity(1.0), fontSize: 15),
                    ),

                  ],
                ),
              ),
              onPressed: () {
                eventIndex=j;
                Event_Admin=eventAdmin;
                Navigator.of(context).pushNamed(EventInfoPage.tag);
              },
            ),
          ],
        ),
      ),
    );
  }
}


