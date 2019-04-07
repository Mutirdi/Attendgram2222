import 'package:flutter/material.dart';
import 'Record_Page.dart';
import 'RecordAdmin.dart';
import 'globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'myData.dart';
import 'search_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'ModifyEvent.dart';
import 'package:flutter_tags/selectable_tags.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'QR.dart';
import 'package:location/location.dart';
import 'package:encrypt/encrypt.dart' as encyprt ;



class EventInfoPage extends StatefulWidget {
  static String tag = 'event-info-page';
  var eventNum = eventIndex;
  bool isActive = false;
  var eventName,  eventAccessability;
  DateTime eventStartingDate = new DateTime(1960), eventFinishingDate = new DateTime(1960), eventStartingTime = new DateTime(0,0,0,0,0), eventFinishingTime = new DateTime(0,0,0,0,0);
  String _participantEmail;
  var occurrences ;
  var occurr=1;
  var lat=45.51562963057538;
  var lon=-122.7902704104781;
  var data;
  var occur=[];
  var recordTable = new List<String>();
  var currentLocation = <String, double>{};
  var location = new Location();




  EventInfoPage(this.eventNum, this.eventName, this.eventStartingDate, this.eventFinishingDate, this.eventStartingTime,
      this.eventFinishingTime, this.eventAccessability, this.lat, this.lon);
  @override
  State<StatefulWidget> createState() {
    return _EventInfoPageState(this.eventNum, this.eventName, this.eventStartingDate, this.eventFinishingDate, this.eventStartingTime,
        this.eventFinishingTime, this.eventAccessability, this.lat, this.lon);
  }
}

class _EventInfoPageState extends State<EventInfoPage> {
  List<myData> allData= [];
  List<Tag> _tags1=[];
  var eventName,  eventAccessability;
  DateTime eventStartingDate = new DateTime(1960), eventFinishingDate = new DateTime(1960), eventStartingTime = new DateTime(0,0,0,0,0), eventFinishingTime = new DateTime(0,0,0,0,0);
  String _participantEmail;
  var occurrences ;
  var occurr=1;
  var lat=45.51562963057538;
  var lon=-122.7902704104781;
  var data;
  var occur=[];
  var recordTable = new List<String>();
  var currentLocation = <String, double>{};
  var location = new Location();
  var tag;
  var QRflag = false ;
  var requiredQR = true;
  IconButton ADDICON;
  IconButton ADDICON1;
  bool _value = false;
  _EventInfoPageState(var eventNum, var eventName, var eventStartingDate, var eventFinishingDate, var eventStartingTime,
      var eventFinishingTime, var eventAccessability, var lat, var lon){
    this.eventName=eventName;
    this.eventStartingDate=eventStartingDate;
    this.eventFinishingDate=eventFinishingDate;
    this.eventStartingTime=eventStartingTime;
    this.eventFinishingTime=eventFinishingTime;
    this.eventAccessability=eventAccessability;
    this.lat=lat;
    this.lon=lon;
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GoogleMapController mapController;
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Events').once().then((DataSnapshot snap) {
      data = snap.value;



      eventName=data[eventIndex]['Event Name'];
      eventStartingDate= new DateTime.fromMillisecondsSinceEpoch(data[eventIndex]['Starting Date']);
      eventFinishingDate= new DateTime.fromMillisecondsSinceEpoch(data[eventIndex]['Finishing Date']);
      eventStartingTime= new DateTime.fromMillisecondsSinceEpoch(data[eventIndex]['Starting Time']);
      eventFinishingTime= new DateTime.fromMillisecondsSinceEpoch(data[eventIndex]['Finishing Time']);
      lat=data[eventIndex]['Lat'];
      lon=data[eventIndex]['Lng'];
      occur=data[eventIndex]['Occur'];
      _value=data[eventIndex]['Disable'];
      requiredQR =data[eventIndex]['RequiredQR'];





      if(data[eventIndex]['Accessability'])
        eventAccessability= "Public";
      else eventAccessability= "Private";

      //CODE TO ADD the participants Email and A's under each occurrence(RECORD TABLE) of this event
      DateTime tempDate = eventStartingDate;
      String s;
      int j=0;
      recordTable.clear();
      while(tempDate.isBefore(eventFinishingDate.add(Duration(days:1)))){
        if(occur[tempDate.weekday-1]){
          s = "${tempDate.day}-${tempDate.month}-${tempDate.year}";
          recordTable.add(s);
          print(recordTable[j]);
          j++;
        }
        tempDate=tempDate.add(Duration(days:1));
      }

      setState(() {
        lat=data[eventIndex]['Lat'];

        lon=data[eventIndex]['Lng'];

        _tags1.addAll([
          Tag(
            id: 1,// optional
            //icon: Icons.access_time, // optional
            title: 'S', // required
            active: occur[6], // optional
          ),
          Tag(
            id: 1,// optional
            //icon: Icons.access_time, // optional
            title: 'M', // required
            active: occur[0], // optional
          ),
          Tag(
            id: 1,// optional
            //icon: Icons.access_time, // optional
            title: 'T', // required
            active: occur[1], // optional
          ),
          Tag(
            id: 1,// optional
            //icon: Icons.access_time, // optional
            title: 'W', // required
            active: occur[2], // optional
          ),
          Tag(
            id: 1,// optional
            //icon: Icons.access_time, // optional
            title: 'T', // required
            active: occur[3], // optional
          ),
          Tag(
            id: 1,// optional
            //icon: Icons.access_time, // optional
            title: 'F', // required
            active: occur[4], // optional
          ),
          Tag(
            id: 1,// optional
            //icon: Icons.access_time, // optional
            title: 'S', // required
            active: occur[5], // optional
          )
        ]
        );
      });

    });







  }


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    mapController.addMarker(MarkerOptions(
        position: LatLng(lat,lon),
        infoWindowText : InfoWindowText(eventName,"")

    ));
    setState(() {
      lat=data[eventIndex]['Lat'];
      lon=data[eventIndex]['Lng'];
    });
    mapController.updateMapOptions(
      GoogleMapOptions(

        myLocationEnabled: true ,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        trackCameraPosition: true,
        cameraPosition: CameraPosition(
          target: LatLng(lat, lon),
          zoom: 11.0,

        ),


      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var sTime = new TimeOfDay(hour: eventStartingTime.hour, minute: eventStartingTime.minute).format(context);
    var fTime = new TimeOfDay(hour: eventFinishingTime.hour, minute: eventFinishingTime.minute).format(context);



    final time = Text(
      'Time: from $sTime, to $fTime',
      style: TextStyle(color: Colors.black54,fontSize: 15.0),
    );

    final date = Text(
      'Date: from ${eventStartingDate.day}/${eventStartingDate.month}'
          '/${eventStartingDate.year}, to ${eventFinishingDate.day}/${eventFinishingDate.month}/${eventFinishingDate.year} \n',
      style: TextStyle(color: Colors.black54,fontSize: 15.0,),
    );

    final type = Text(
      'Type: ${eventAccessability}',
      style: TextStyle(color: Colors.black54,fontSize: 15.0,),
    );

    final myRecord = FlatButton(
      child: Text(
        'My Record',
        style: TextStyle(color: Colors.black54,fontSize: 15.0,),
      ),
      onPressed: _CheckAdmin(Event_Admin) == true ? (){Navigator.of(context).pushNamed(RecordAdmin.tag);} : () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => RecordPage(globalUserId),
        ));
      },
    );

    final requestTimeOff = FlatButton(
      child: Text(
        'Request Time Off',
        style: TextStyle(color: Colors.black54,fontSize: 15.0),
      ),
      onPressed: () {
      },
    );

    final requestLeave = FlatButton(
      child: Text(
        'Request Leave',
        style: TextStyle(color: Colors.black54,fontSize: 15.0),
      ),
      onPressed: () {
      },
    );

    final recordIcon = Icon(Icons.featured_play_list);
    final timeOffIcon = Icon(Icons.watch_later);
    final leaveIcon = Icon(Icons.directions_walk);

    ADDICON = IconButton(
      icon: Icon(Icons.person_add,size: 25.0,color: Color(0xFF18D191)),
      onPressed: _addParticipantPopUp,
    );
    ADDICON1 = IconButton(
      icon: Icon(Icons.person_add,size: 1.0,color: Color(0xFFFFFFFF)),

    );





    return Scaffold(
      appBar: AppBar(


        title: new Text('$eventName',style: new TextStyle(
            fontSize: 16.5,
            color: Colors.black ,fontWeight: FontWeight.bold)),

        centerTitle: true,

        backgroundColor:Colors.transparent,
        elevation: 0.0,
        iconTheme: new IconThemeData(color: Color(0xFF18D191)),
        actions: <Widget>[



          _CheckAdmin1(Event_Admin),

          Visibility(
            child:
                  IconButton(
                    icon: Icon(Icons.edit,size: 25.0,color: Color(0xFF18D191)),
                    onPressed:  () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ModifyEvent(),
//                            ModifyEvent(eventName, eventStartingDate, eventFinishingDate, eventStartingTime, eventFinishingTime,
//                        occur, true, _value, requiredQR, lat, lon),
                      ));
                    },
                  ),
            visible: _CheckAdmin(Event_Admin),
          ),


        ],
      ),

      backgroundColor: Colors.white,
      body:Form(
        child:  ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 40.0),
            Row(children: <Widget>[
              Text(
                'Description',
                style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold,),

              ),
            ],),


            new Divider(height: 20.0,),

            Text(
              'Weekly Event to improve education attendance methodology...',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 60.0),
            Row(children: <Widget>[
              Text(
                'Date and Time',
                style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold,),

              ),
            ],),


            new Divider(height: 20.0,),

            time,
            SizedBox(height: 10.0),
            date,
            Text(
              'Weekdays: ',
              style: TextStyle(color: Colors.black54,fontSize: 15.0),
            ),
            SizedBox(height: 8.0),
            SelectableTags(
              tags: _tags1,
              color: Colors.white,
              activeColor: Color(0xFF18D191),
              columns: 8, // default 4
              symmetry: true, // default false
              alignment: MainAxisAlignment.center,
              onPressed: (tag){
                if(tag.active){
                  tag.active=false;
                }else{
                  tag.active=true;
                }
                print(tag);
              },
            ),
            SizedBox(height: 40.0),
            Row(children: <Widget>[
              Text(
                'Status',
                style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold,),

              ),
            ],),

            //SizedBox(height: 35.0),
            new Divider(height: 20.0,),
            type,
            SizedBox(height: 20.0),
            Text('State: Active',style: TextStyle(color: Colors.black54,fontSize: 15.0),),
            SizedBox(height: 60.0),
            Row(children: <Widget>[
              Text(
                'Control',
                style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold,),

              ),
            ],),

            //SizedBox(height: 35.0),
            new Divider(height: 20.0,),
            Center(
              child: new Row(
                children: <Widget>[recordIcon, myRecord],
              ),
            ),

            SizedBox(height: 15.0),
            Center(
              child: new Row(
                children: <Widget>[timeOffIcon, requestTimeOff],
              ),
            ),
            SizedBox(height: 15.0),
            Center(
              widthFactor: 25,
              child: new Row(
                children: <Widget>[leaveIcon, requestLeave],
              ),
            ),


            SizedBox(height: 20.0),
            Visibility(
              child: Material(

                child: new Row(
                  children: <Widget>[
                    Text(
                      'Disable Attendance:   ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    new Switch(activeColor: Color(0xFF18D191), value: _value, onChanged: (bool value){_onChanged(value);}),
                  ],
                ),

              ),
              visible: _CheckAdmin(Event_Admin),
            ),
            SizedBox(height: 20.0),
            Visibility(
              child: Material(

                child: new Row(
                  children: <Widget>[
                    Text(
                      'QR Confirmation:             ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    new Switch(activeColor: Color(0xFF18D191), value: requiredQR, onChanged: (bool value){_onChanged(value);}),
                  ],
                ),

              ),
              visible: _CheckAdmin(Event_Admin),
            ),




            SizedBox(height: 100.0),
            Row(children: <Widget>[
              Text(
                'Location',
                style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold,),

              ),
            ],),

            //SizedBox(height: 35.0),
            new Divider(height: 20.0,),
            SizedBox(height: 20.0),
            SizedBox(
              height: 400.0,
              width: 200.0,
              child: Stack(

                children: <Widget>[
                  GoogleMap(

                    onMapCreated: _onMapCreated,

                    options: GoogleMapOptions(
                      myLocationEnabled: true ,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      trackCameraPosition: true,
                      cameraPosition: CameraPosition(
                        target: LatLng(lat, lon),
                        zoom: 11.0,
                      ),
                    ),
                  ),



                ],
              ),
            ),
            SizedBox(height: 40.0),
            Center(
                child: _CheckAdmin(Event_Admin) == true ? new Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Colors.lightBlue.shade100,
                  elevation: 5.0,
//                  child: GestureDetector(
//                    onTap: _addParticipantPopUp,
//                    child: new Container(
//                      alignment: Alignment.center,
//                      height: 60.0,
//                      decoration: new BoxDecoration(
//                          color: Color(0xFF18D191) ,
//                          borderRadius: new BorderRadius.circular(15.0)),
//                      child: new Text("Add Participant",
//                        style: new TextStyle(
//                          fontSize: 25.0,
//                          color: Colors.white,
//                      ),
//                     ),
//                    ),
//                 ),
                )
                    : _decide()
            ),


            SizedBox(height: 8.0),
            Visibility(
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.lightBlue.shade100,
                elevation: 5.0,
                child: GestureDetector(
                  onTap: _QrPage,
                  child: new Container(
                    alignment: Alignment.center, height: 60.0,
                    decoration: new BoxDecoration(
                        color: Color(0xFF18D191) ,
                        borderRadius: new BorderRadius.circular(15.0)),
                    child: new Text("Take Attendance",
                      style: new TextStyle(
                        fontSize: 25.0, color: Colors.white,
                      ),
                    ),

                  ),
                ),
              ),
              visible: _CheckAdmin(Event_Admin),
            ),
            SizedBox(height: 8.0),
            Visibility(
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.lightBlue.shade100,
                elevation: 5.0,
                child: GestureDetector(
                  onTap: _QrPage,
                  child: new Container(
                    alignment: Alignment.center, height: 60.0,
                    decoration: new BoxDecoration(
                        color: Color(0xFF18D191) ,
                        borderRadius: new BorderRadius.circular(15.0)),
                    child: new Text("Scan QR",
                      style: new TextStyle(
                        fontSize: 25.0, color: Colors.white,
                      ),
                    ),

                  ),
                ),
              ),
              visible: !_CheckAdmin(Event_Admin),
            ),

          ],
        ),
      ),
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

  Future<void> _AttendenceConfirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attendence Confirmed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You attended seccessfully'),
                //Text('reset your password'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  _CheckAdmin1(AdminID){

    if(AdminID==globalUserId) {
      return ADDICON;
    }else{
      return  ADDICON1;
    }


  }


  _CheckAdmin(AdminID){

    if(AdminID==globalUserId) {
      return true;
    }

    return false ;
  }

  _decide(){

    print(currentEventIDs);
    if (currentEventIDs.values.contains('$eventIndex')){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0),
              child: GestureDetector(
                onTap: _CheckActive() != true ? _notActivePopUp : () {
                  if(requiredQR){
                    _QrPage();
                    if(QRflag){
                      DatabaseReference ref = FirebaseDatabase.instance.reference();
                      ref.child("Events").child('$eventIndex').child('Record Table').child("${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}").child(currentUserName).set("P");
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Attendance Confirmed'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text("Attendance has been succesfully confrmed!"),

                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Confirm'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }

                  else {
                    DatabaseReference ref = FirebaseDatabase.instance.reference();
                    ref.child("Events").child('$eventIndex').child(
                        'Record Table').child("${DateTime
                        .now()
                        .day}-${DateTime
                        .now()
                        .month}-${DateTime
                        .now()
                        .year}").child(currentUserName).set("P");
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Attendance Confirmed'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                    "Attendance has been succesfully confrmed!"),

                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Confirm'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }},
                child: new Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  decoration: new BoxDecoration(
                      color: checkDisAndAct() == true  ? Color(0xFF18D191) : Colors.black54,
                      borderRadius: new BorderRadius.circular(15.0)),
                  child: new Text("Confirm Attendance",
                    style: new TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25.0),
        ],

      );

    }
    else{
      return new Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlue.shade100,
        elevation: 5.0,
        child: GestureDetector(
          onTap: _joinEvent,
          child: new Container(
            alignment: Alignment.center,
            height: 60.0,
            decoration: new BoxDecoration(
                color: Color(0xFF18D191) ,
                borderRadius: new BorderRadius.circular(15.0)),
            child: new Text("Join Event",
              style: new TextStyle(
                fontSize: 25.0,
                color: Colors.white,
              ),
            ),

          ),
        ),
      );
    }
  }

  bool _CheckActive (){
    getUserLocation();
    DateTime currentTime = new DateTime(0, 0, 0, TimeOfDay.now().hour, TimeOfDay.now().minute);
    print(recordTable.contains("${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"));
    print(eventStartingTime.isBefore(currentTime));
    print(eventFinishingTime.isAfter(currentTime));
    print(eventFinishingTime);
    print(currentTime);
    if(eventStartingTime.isBefore(currentTime) && eventFinishingTime.isAfter(currentTime) && recordTable.contains("${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}")&& (currentLocation["latitude"]).toStringAsFixed(4)==lat.toStringAsFixed(4) && (currentLocation["longitude"]).toStringAsFixed(4)==lon.toStringAsFixed(4)){
      print("ITS ON TIME");
      return true ;
    }
    return false ;
  }




  Future<void> _addParticipantPopUp() async{

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Form( key: _formKey ,
          child : AlertDialog(
            title: Text('Enter User Email'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,

                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      hintText: 'Type Event Name ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                    onSaved: (input) => _participantEmail = input,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Confirm'),
                onPressed: _addParticipant,
              ),
            ],
          ),
        );
      },
    );

  }

  Future<void> _joinEvent() async {
    DatabaseReference Ref = FirebaseDatabase.instance.reference();
    Ref.child('Users').child(globalUserId).child('Event_Ids').child(eventIndex).set(eventIndex);
    Map<dynamic,dynamic> map ;
    Ref.child('Users').child(globalUserId).once().then((DataSnapshot snap) {
      map = snap.value;
      currentEventIDs = map['Event_Ids'] ;
      //print(currentEventIDs);
      int j=0;
      for(j=0; j<recordTable.length ; j++){
        Ref.child('Events').child(eventIndex).child("Record Table").child(recordTable[j]).child(globalUserId).child(currentUserName).set("A");
      }
      setState(() {
      });

    });
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Added'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You Joined this Event Successfully'),
                // Text('reset your password'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );



  }

  checkDisAndAct(){

    if(_CheckActive() && _value == false){

      return true;


    }
    else{

      return false;
    }


  }



  _notActivePopUp(){

    if(_value==true){
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error Occurred'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Event attendance is not activated ."),

                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    else {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error Occurred'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Event is not active yet."),

                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
  _QrPage() async {
    var code = "$eventIndex${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

    final key = encyprt.Key.fromUtf8('my 32 length key................');
    final iv = encyprt.IV.fromLength(16);
    final encrypter = encyprt.Encrypter(encyprt.AES(key, iv));
    final encrypted = encrypter.encrypt(code);
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COOOOOOOOOOOOOOOOOOODE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    print(encrypted.base64);
    if (_CheckAdmin(Event_Admin)) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => QR(encrypted.base64),
      ));
    }
    else {
      String futureString = await QRCodeReader().scan();
      print("############################" + futureString);
      if(futureString == encrypted.base64){
        print("####################################-> we are here");
        setState(() {
          QRflag = true ;
        });

        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('QR Success'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('You scanned $eventName successfully'),
                    // Text('reset your password'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

      }

    }


  }


  void _onChanged(bool value){
    setState(() {
      _value = value;
      DatabaseReference Ref = FirebaseDatabase.instance.reference() ;
      var eventID = Ref.child('Events').child(eventIndex).update({
        "Disable":_value
      }
      );
    });


  }
  void _onQrChanged(bool value) {
    setState(() {
      requiredQR = value;
      DatabaseReference Ref = FirebaseDatabase.instance.reference();
      var eventID = Ref.child('Events').child(eventIndex).update({
        "RequiredQR": requiredQR
      }
      );
    });
  }



  Future<void> _addParticipant() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        DatabaseReference Ref = FirebaseDatabase.instance.reference() ;
        var userList = Ref.child('Users').once();
        var _participantName; // To store the added participant's name to the record table.
        bool found = false;
        userList.then((DataSnapshot snap){
          Map<dynamic,dynamic> map = snap.value ;
          var keys = map.entries;
          var values = map.values;

          print("keysssss : ${keys}");

          keys.forEach((k){
            Map<dynamic,dynamic> map1 = k.value ;
            var UserFields = map1.entries ;
            var UserValues = map1.values;

            print(' ############################## \n UserFieilds: $UserFields\n UserValues:$UserValues\n  Values:$values \n Keys:$keys ');

            UserFields.forEach((i){

              if(i.key == 'email'){

                if(i.value == _participantEmail){
                  found=true;
                  print("FOUND IT : ${i.value}");
                  print("k.key : ${k.key}");
                  Ref.child('Users').child(k.key).child('Event_Ids').child(eventIndex).set(
                      eventIndex
                  );

                  return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('User Added'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('A new participant is added Successfully'),
                              // Text('reset your password'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Confirm'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }
              if(i.key == 'Name' && found==true){ //To update record table with participant's name.
                _participantName=i.value;
                int j=0;
                print("RECOOOOOOOOOOOOOOOOORD LENGTH");
                print(recordTable.length);
                for(j=0; j<recordTable.length ; j++){
                  Ref.child('Events').child(eventIndex).child("Record Table").child(recordTable[j]).child(k.key).child(_participantName).set("A");
                }
                found = false; //Reset found flag.
              }
            });//internal loop
          });// external loop
        });



      }catch(e){
        print(e.message);
      }
    }
  }





  Future<void> _leaveRequest(String e) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Leave Request'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(height: 20.0),

                Text(
                  'Leave Request: ',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  validator: (val) => val.isEmpty ? 'Event name can\'t be empty.' : null,

                  decoration: InputDecoration(
                    counterText: "100",
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    hintText: 'Ex: Annualy Conferance for new Apple products ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),),

                  ),
                  //onSaved: (input) => _eventName = input,
                ),

                SizedBox(height: 20.0),

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Send'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}