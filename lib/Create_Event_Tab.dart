
import 'package:firebase_auth/firebase_auth.dart';
import 'home_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'globals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'login.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_tags/input_tags.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_tags/selectable_tags.dart';
import 'package:location/location.dart';


class CreateEventTab extends StatefulWidget {
  static String tag = 'login-page';
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
  @override
  _CreateEventState createState() => new _CreateEventState();
}

class _CreateEventState extends State<CreateEventTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GoogleMapController mapController;
  final myController = TextEditingController();
  var location = new Location();
  LatLng center = LatLng(currentLocation["latitude"], currentLocation["longitude"]);
  bool firstTimeMap=true ;


  var recordTable = new List<String>();
  bool _value = false;
  bool Disable=false;
  bool requiredQR = true;
  List<String> _tags=[];
  List<Tag> _tags1=[];
  List<bool> occur = [false, false, false, false, false, false, false];
  String _eventName ;
  String FinishingDateText = "Select Finishing Date", StartingDateText="Select Starting Date", FinishingTimeText= "Select Finishing Time", StartingTimeText= "Select Starting Time";
  DateTime  startingDate, finishingDate ;
  DateTime eventStartingTime, eventFinishingTime ;

  var success = false ;
  String LocationName= '' ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();







    _tags1.addAll([
      Tag(
        id: 6,// optional
        //icon: Icons.access_time, // optional
        title: 'S', // required
        active: occur[0], // optional
      ),
      Tag(
        id: 0,// optional
        //icon: Icons.access_time, // optional
        title: 'M', // required
        active: occur[1], // optional
      ),
      Tag(
        id: 1,// optional
        //icon: Icons.access_time, // optional
        title: 'T', // required
        active: occur[2], // optional
      ),
      Tag(
        id: 2,// optional
        //icon: Icons.access_time, // optional
        title: 'W', // required
        active: occur[3], // optional
      ),
      Tag(
        id: 3,// optional
        //icon: Icons.access_time, // optional
        title: 'T', // required
        active: occur[4], // optional
      ),
      Tag(
        id: 4,// optional
        //icon: Icons.access_time, // optional
        title: 'F', // required
        active: occur[5], // optional
      ),
      Tag(
        id: 5,// optional
        //icon: Icons.access_time, // optional
        title: 'S', // required
        active: occur[6], // optional
      )
    ]
    );

  }





  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding : false,
      appBar: new AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.menu,color: Color(0xFF18D191)),
                iconSize: 25.0

            );
          },
        ),

        title: new Text('Create Event',style: new TextStyle(
            fontSize: 25.0,
            color: Color(0xFF18D191) )),
        centerTitle: true,
        backgroundColor:Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done,size: 25.0,color: Color(0xFF18D191)),
            onPressed:_eventCreated,
          ),
        ],

      ),


      drawer: new Drawer(

          child: new ListView(

            children: <Widget>[

              new UserAccountsDrawerHeader(

                decoration: new BoxDecoration(
                    color: Color(0xFF18D191)),
                accountName: new Text('$currentUserName',style: TextStyle(fontSize: 25.0, color: Colors.white),),
                accountEmail: new Text("mahmood@gmail.com"),
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
      backgroundColor: Colors.white,


      body:Form(
        key: _formKey,
        child: ListView(

            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[

              SizedBox(height: 24.0),
              Text(
                'Event Name: ',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                keyboardType: TextInputType.text,
                autofocus: false,
                validator: (val) => val.isEmpty ? 'Event name can\'t be empty.' : null,
                initialValue: _eventName,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  hintText: 'Type Event Name ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
                onSaved: (input) => _eventName = input,
                controller: myController,

              ),

              SizedBox(height: 35.0),
              Center(
                child: new Row(
                  children: <Widget>[
                    Text(
                      'Starting Time:   ',
                      style: TextStyle(color: Colors.black54),
                    ),
                Align(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                    padding: EdgeInsets.only(left: 141.5),
                    textColor:  Color(0xFF18D191),
                    child: const Icon(Icons.access_time, size: 30.0),
                    onPressed: _selectStartingTime,
                  ),
                ),],
                ),
              ),
              SizedBox(height: 35.0),
              Center(
                child: new Row(
                  children: <Widget>[
                    Text(
                      'Finishing Time: ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: FlatButton(
                        padding: EdgeInsets.only(left: 141.5),
                        textColor:  Color(0xFF18D191),
                        child: const Icon(Icons.access_time, size: 30.0),
                        onPressed: _selectFinishingTime,
                      ),
                    ),],
                ),
              ),
//              SizedBox(height: 20.0),
//              Center(
//                child: new Row(
//                  children: <Widget>[
//                    Text(
//                      'Starting Date:          ',
//                      style: TextStyle(color: Colors.black54),
//                    ),
//                    RaisedButton (
//                      child: Text('$StartingDateText'),
//                      onPressed: _startingDatePicker ,
//                      color: Color(0xFF18D191),
//                      textColor:  Colors.white,
//                    ),
//                  ],
//                ),
//              ),
//              SizedBox(height: 20.0),
//              Center(
//                child: new Row(
//                  children: <Widget>[
//                    Text(
//                      'Finishing Date:       ',
//                      style: TextStyle(color: Colors.black54),
//                    ),
//                    RaisedButton (
//                      child: Text('$FinishingDateText'),
//                      onPressed: _finishingDatePicker ,
//                      color: Color(0xFF18D191),
//                      textColor:  Colors.white,
//                    ),
//                  ],
//                ),
//              ),




              SizedBox(height: 20.0),
              Center(
                child: new Row(
                  children: <Widget>[
                    Text(
                      ' Date:',
                      style: TextStyle(color: Colors.black54),
                    ),
                    new FlatButton(
                      padding: EdgeInsets.only(left: 200.0),
                      textColor:  Color(0xFF18D191),
                      child: const Icon(Icons.calendar_today, size: 30.0),
                      onPressed: () async {
                        final List<DateTime> picked = await DateRagePicker.showDatePicker(
                            context: context,
                            initialFirstDate: new DateTime.now(),
                            initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
                            firstDate: new DateTime(2015),
                            lastDate: new DateTime(2020)
                        );
                        if (picked != null && picked.length == 2) {
                          startingDate = new DateTime(picked[0].year,picked[0].month,picked[0].day);
                          finishingDate = new DateTime(picked[1].year,picked[1].month,picked[1].day);
                        }
                      },
                    ),
                  ],
                ),
              ),





              SizedBox(height: 20.0),
              Center(
                child: new Row(
                  children: <Widget>[
                    Text(
                      'Public:   ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    new Switch(activeColor: Color(0xFF18D191), value: _value, onChanged: (bool value){_onChanged(value);}),
                  ],
                ),
              ),

              SizedBox(height: 20.0),
              Text(
                'Weekdays: ',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 10.0),
              SelectableTags(
                tags: _tags1,
                color: Colors.white,
                activeColor: Color(0xFF18D191),
                columns: 8, // default 4
                symmetry: true, // default false
                alignment: MainAxisAlignment.center,
                onPressed: (tag){
                  if(tag.active){
                    occur[tag.id]=true;
                  }else{
                    occur[tag.id]=false;
                  }
                  print(tag);
                },
              ),




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
                          target: center,
                          zoom: 11.0,
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: FloatingActionButton(
                          onPressed:
                          firstTimeMap == true ? _onAddMarkerButtonPressed : _confirmAddPlace,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor:  Color(0xFF18D191),
                          child: const Icon(Icons.pin_drop, size: 36.0),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(2.5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: FloatingActionButton(
                          onPressed:
                          locateUser,
                          backgroundColor:  Color(0xFF18D191),
                          child: const Icon(Icons.person, size: 36.0),
                        ),
                      ),
                    ),





//

                    Padding(
                      padding: const EdgeInsets.fromLTRB(00, 185, 0, 0),
                      child: Align(
                        alignment: Alignment.centerRight,

                        child: FloatingActionButton(

                          onPressed:(){

                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );},

                          backgroundColor: Colors.transparent ,
                          child: new IconTheme(
                            data: new IconThemeData(
                                color: Colors.green),
                            child: new Icon(Icons.add
                                ,size: 35.0),
                          ),
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.fromLTRB(255, 10, 0, 10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FloatingActionButton(
                          onPressed:(){

                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );},
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.transparent ,
                          child: new IconTheme(
                            data: new IconThemeData(
                                color: Colors.green),
                            child: new Icon(Icons.minimize,size: 30.0),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 20),
          SizedBox(
            height: 40.0,
            width: 200.0,
            child: Stack(

              children: <Widget>[











              ],
            ),
          ),

          SizedBox(height: 20.0),






            ]
        ),
      ),
    );
  }

  Marker _pendingMarker;


  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }

  Future<Map<String,double>>locateUser() async {
    var currentLocation = await location.getLocation();

      if (currentLocation != null) {
        if(!firstTimeMap){
          mapController.updateMarker(
            _pendingMarker,
            MarkerOptions(
              position: LatLng(
                currentLocation['latitude'],
                currentLocation['longitude'],
              ),
              icon: BitmapDescriptor.defaultMarker,
              draggable: false,
            ),
          );
          setState(() {
            mapController.updateMapOptions(
              GoogleMapOptions(

                myLocationEnabled: true ,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                trackCameraPosition: true,
                cameraPosition: CameraPosition(
                  target: LatLng(currentLocation['latitude'], currentLocation['longitude']),
                  zoom: 11.0,

                ),
              ),
            );
          });
         }
         else{
          Marker newMarker = await mapController.addMarker(
              MarkerOptions(
                position: LatLng(
                  currentLocation['latitude'],
                  currentLocation['longitude'],
                )
            )

          );
          setState(() {
            _pendingMarker = newMarker ;
            firstTimeMap = false ;
            mapController.updateMapOptions(
              GoogleMapOptions(

                myLocationEnabled: true ,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                trackCameraPosition: true,
                cameraPosition: CameraPosition(
                  target: LatLng(currentLocation['latitude'], currentLocation['longitude']),
                  zoom: 11.0,

                ),
              ),
            );
          });

          }
        }


    }


  void _onAddMarkerButtonPressed() async {
    print("here");
    Marker newMarker = await  mapController.addMarker(
      MarkerOptions(
        position: LatLng(
          mapController.cameraPosition.target.latitude,
          mapController.cameraPosition.target.longitude,
        ),
        infoWindowText: InfoWindowText('Your Event Lacation ', ''),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    setState(() {
      firstTimeMap = false ;
      _pendingMarker = newMarker ;
    });

  }


  void _confirmAddPlace() {
    print("yyyyhere");
    mapController.updateMarker(
      _pendingMarker,
      MarkerOptions(
        position: LatLng(
          mapController.cameraPosition.target.latitude,
          mapController.cameraPosition.target.longitude,
        ),
        icon: BitmapDescriptor.defaultMarker,
        draggable: false,
      ),
    );

    print(_pendingMarker.options.position.latitude);
    print(_pendingMarker.options.position.longitude);



  }





  Future<void> _updateExistingPlaceMarker() async {


    // Set marker visibility to false to ensure the info window is hidden. Once
    // the plugin fully supports the Google Maps API, use hideInfoWindow()
    // instead.
    await mapController.updateMarker(
      _pendingMarker,
      MarkerOptions(
        visible: true,
      ),
    );


  }

  void _onAddPlacePressed() async {
    print("here");
    Marker newMarker = await mapController.addMarker(
      MarkerOptions(
        position: LatLng(
          mapController.cameraPosition.target.latitude,
          mapController.cameraPosition.target.longitude,
        ),
        draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen),
      ),
    );
    _pendingMarker = newMarker;
    _confirmAddPlace;

  }






  void _onPlaceChanged() {
    // Replace the place with the modified version.



    // Manually update our map configuration here since our map is already
    // updated with the new marker. Otherwise, the map would be reconfigured
    // in the main build method due to a modified AppState.



  }


  Future<void> _eventCreated() async {

    _createEventCall();

    if(success){

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Event Created'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('A new event are created Successfully'),
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




  Future<void> _occurInit() async {
    for(int i = 0; i < 8; i++){
      occur[i] = false;
    }
    setState(() {});
  }
  Future<void> _startingDatePicker() async {
    final DateTime picker = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );
    StartingDateText="${picker.day}/${picker.month}/${picker.year}";
    startingDate = new DateTime(picker.year, picker.month, picker.day);

    setState(() {});
  }

  Future<void> _finishingDatePicker() async {
    final DateTime picker = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );
    FinishingDateText="${picker.day}/${picker.month}/${picker.year}";
    finishingDate = new DateTime(picker.year, picker.month, picker.day);



    setState(() {});
  }

  Future<void> _selectStartingTime() async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: new TimeOfDay.now(),
    );
    StartingTimeText = picked.format(context);
    eventStartingTime =  new DateTime(0, 0, 0, picked.hour, picked.minute);

    setState(() {

    });
  }


  Future<void> _selectFinishingTime() async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: new TimeOfDay.now(),
    );
    FinishingTimeText = picked.format(context);
    eventFinishingTime =  new DateTime(0, 0, 0, picked.hour, picked.minute);
    setState(() {

    });
  }
  void _onChanged(bool value){
    setState(() {
      _value = value;
    });
  }

  void _onChangedDays(var i, bool value){
    setState(() {
      occur[i] = value;
    });
  }

  Future<void> _createEventCall() async {
    if(_formKey.currentState.validate() ){
      _formKey.currentState.save();

      // NOW WE CHECK FOR 3 ERRORS

      // ERROR 1: if starting date is after finishing date.
      if(startingDate.isAfter(finishingDate)){
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error Occurred'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("Event finishing date is before the starting date."),

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



      // ERROR 2: if time exceeds finishing date.
      else if (occur[finishingDate.weekday-1] == true && eventStartingTime.isAfter(eventFinishingTime)){
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error Occurred'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("Event Time Exceeds The Selected Date."),

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
      else{
        
        //Error 3: if a selected weekday is not in the date range. (ONLY HAPPENS WHEN THE EVENT IS LESS THAN 7 DAYS)
        if(startingDate.difference(finishingDate).inDays < 7){
          DateTime temp = startingDate;
          for(int j =0; j < 7; j++){
            if(occur[temp.weekday-1] == true && temp.isAfter(finishingDate)){
              print(temp.day);
              return showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error Occurred'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(" A Weekday is selected after the finished date."),

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
            temp=temp.add(Duration(days:1));
          }
        }
          try{
              success=true;
            DatabaseReference Ref = FirebaseDatabase.instance.reference() ;
            final coordinates = new Coordinates( _pendingMarker.options.position.latitude, _pendingMarker.options.position.longitude);
            var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
            var first = addresses.first;
            LocationName=first.featureName.toString();
            // THIS CODE GENERATES THE RECORD TABLE USING OCCUR(WEEKDAYS) and STARTING AND FINISHING DATES OF THE EVENT!
            DateTime tempDate = startingDate;
            int i=0;
            String s;
            recordTable.clear();
            while(tempDate.isBefore(finishingDate.add(Duration(days:1)))){
              if(occur[tempDate.weekday-1]){
                s = "${tempDate.day}-${tempDate.month}-${tempDate.year}";
                recordTable.add(s);
                print(recordTable[i]);
                i++;
              }
              tempDate=tempDate.add(Duration(days:1));
            }
            //RECORD TABLE GENERATED ! SAVED TO DATA BASE IN LINE 666 \m/ >:D !
            var eventKey =Ref.child('Events').push().key;
            var eventID=Ref.child('Events').child(eventKey).set(
                {

                  "Starting Time" : eventStartingTime.millisecondsSinceEpoch, "Finishing Time" : eventFinishingTime.millisecondsSinceEpoch
                  , "Starting Date" : startingDate.millisecondsSinceEpoch, "Finishing Date" : finishingDate.millisecondsSinceEpoch
                  , "Accessability" : _value, "AdminID" : globalUserId, "Occur" : occur ,"Location Name":LocationName, "Lat" : _pendingMarker.options.position.latitude
                  , "Lng" : _pendingMarker.options.position.longitude,
                  "Event Name": myController.text,"Disable":Disable , "RequiredQR":requiredQR,
                }

            );

            // THIS CODE ADDS THE RECORD TABLE TO THE DATABASE!
            for(i=0; i<recordTable.length ; i++){
              Ref.child('Events').child(eventKey).child("Record Table").child(recordTable[i]).set(recordTable[i]);
            }

            Ref.child('Users').child(globalUserId).child('Event_Admin').child(eventKey).set(eventKey);
            Ref.child('Users').child(globalUserId).child('Event_Ids').child(eventKey).set(eventKey);

            // I Need to add the event to the event list in the user
            // Ref.child('Users').child(globalUserId).child('Event_Ids').setPriority(eventKey) ;


          }catch(e){
            print(e.message);
          }

      }
    }
  }
}