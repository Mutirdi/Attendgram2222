
import 'package:firebase_auth/firebase_auth.dart';
import 'home_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'globals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'login.dart';
import 'package:flutter_tags/input_tags.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_tags/selectable_tags.dart';
import 'event_info_page.dart';




class ModifyEvent extends StatefulWidget {
  static String tag = 'modify-event-page';
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
  @override
  _ModifyEventState createState() => new _ModifyEventState();
}

class _ModifyEventState extends State<ModifyEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GoogleMapController mapController;
  final LatLng center = const LatLng(45.521563, -122.677433);
  bool firstTimeMap=true ;
  final myController = TextEditingController();
  List<String> _tags=[];
  List<Tag> _tags1=[];

  bool _value = false;
  bool _value2 = false;
  List<bool> occur = [false, false, false, false, false, false, false];
  var _eventName ;
  String FinishingDateText = "Select Finishing Date", StartingDateText="Select Starting Date", FinishingTimeText= "Select Finishing Time", StartingTimeText= "Select Starting Time";
  DateTime  startingDate, finishingDate ;
  DateTime eventStartingTime, eventFinishingTime ;

  var success = false ;

  var _volume = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding : false,
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Color(0xFF18D191)),

        title: new Text('Modify Event',style: new TextStyle(
            fontSize: 25.0,
            color: Colors.black )),
        centerTitle: true,
        backgroundColor:Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done,size: 25.0,color: Color(0xFF18D191)),
            onPressed:_eventModified,
          ),
        ],
      ),

      backgroundColor: Colors.white,


      body:Form(

        key: _formKey,
        child: ListView(

            padding: EdgeInsets.only(left: 30.0, right: 30.0),

            children: <Widget>[

              SizedBox(height: 40.0),




              Row(children: <Widget>[
                Text(
                  'Details',
                  style: TextStyle(color: Colors.black,fontSize: 25.0,fontWeight: FontWeight.bold,),

                ),
              ],),

              //SizedBox(height: 35.0),
              new Divider(height: 20.0,),



              Text(
                'Event Pic: ',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 5.0),
              Row(children: <Widget>[
                Image.asset(

                  'assets/images/add.png',
                  height: 70,
                  width: 70,

                ),
              ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Event Name: ',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 5.0),
              TextFormField(
                keyboardType: TextInputType.text,
                autofocus: false,
                validator: (val) => val.isEmpty ? 'Event name can\'t be empty.' : null,
                initialValue: _eventName,
                decoration: InputDecoration(
                  counterText: "100",
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  hintText: 'Ex: Apple Conferance ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
                onSaved: (input) => _eventName = input,
                controller: myController,
              ),

              SizedBox(height: 20.0),
              Text(
                'Event Description: ',
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
                onSaved: (input) => _eventName = input,
              ),

              SizedBox(height: 20.0),
              Text(
                'Interests: ',
                style: TextStyle(color: Colors.black54),
              ),
              InputTags(
                tags: _tags,
                color: Color(0xFF18D191),
                alignment: MainAxisAlignment.start,
                onDelete: (tag){
                  print(tag);
                },
                onInsert: (tag){
                  print(tag);
                },
              ),



              SizedBox(height: 60.0),
              Row(children: <Widget>[
                Text(
                  'Date and Time',
                  style: TextStyle(color: Colors.black,fontSize: 25.0,fontWeight: FontWeight.bold,),

                ),
              ],),

              //SizedBox(height: 35.0),
              new Divider(height: 20.0,),
              Center(
                child: new Row(
                  children: <Widget>[
                    Text(
                      'Starting Time: ',
                      style: TextStyle(color: Colors.black54),
                    ),

                    //Text(
                    //'${StartingTimeText} ',
                    //style: TextStyle(color: Colors.black54),
                    //),
                    FlatButton(
                      padding: EdgeInsets.only(left: 146.0),
                      textColor:  Color(0xFF18D191),
                      child: const Icon(Icons.access_time, size: 30.0),
                      onPressed: _selectStartingTime,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Center(

                child: new Row(
                  children: <Widget>[
                    Text(
                      'Finishing Time:',
                      style: TextStyle(color: Colors.black54),
                    ),
                    //Text(
                    //'${FinishingTimeText}  ',
                    //style: TextStyle(color: Colors.black54),
                    //),
                    Align(
                      alignment: Alignment.topRight,
                      child: FlatButton(
                        padding: EdgeInsets.only(left: 141.5),
                        textColor:  Color(0xFF18D191),
                        child: const Icon(Icons.access_time, size: 30.0),
                        onPressed: _selectFinishingTime,
                      ),
                    ),

                  ],
                ),
              ),
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
                  print(tag);
                },
              ),

              SizedBox(height: 40.0),
              Row(children: <Widget>[
                Text(
                  'Status',
                  style: TextStyle(color: Colors.black,fontSize: 25.0,fontWeight: FontWeight.bold,),

                ),
              ],),

              //SizedBox(height: 35.0),
              new Divider(height: 25.0,),
              Center(
                child: new Row(
                  children: <Widget>[
                    Text(
                      'Public:',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      '                                                         ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    new Switch(activeColor: Color(0xFF18D191), value: _value, onChanged: (bool value){_onChanged(value);}),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: new Row(
                  children: <Widget>[
                    Text(
                      'Disable Attendance:',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      '                                 ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    new Switch(activeColor: Color(0xFF18D191), value: _value2, onChanged: (bool value){_onChanged2(value);}),
                  ],
                ),
              ),

              SizedBox(height: 60.0),
              Row(children: <Widget>[
                Text(
                  'Location',
                  style: TextStyle(color: Colors.black,fontSize: 25.0,fontWeight: FontWeight.bold,),

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
                          target: center,
                          zoom: 11.0,
                        ),
                      ),
                    ),



                    Padding(
                      padding: const EdgeInsets.all(16.0),
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
                  ],
                ),
              ),



              SizedBox(height: 10.0),

            ]
        ),
      ),
    );
  }

  Marker _pendingMarker;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onAddMarkerButtonPressed() async {
    print("here");
    Marker newMarker = await  mapController.addMarker(
      MarkerOptions(
        position: LatLng(
          mapController.cameraPosition.target.latitude,
          mapController.cameraPosition.target.longitude,
        ),
        infoWindowText: InfoWindowText('Random Place', '5 Star Rating'),
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


  Future<void> _eventModified() async {

    _createEventCall();

    if(success){

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Event Modified'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Event has been modified successfully'),
                  // Text('reset your password'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context) => EventInfoPage(eventIndex, _eventName, startingDate, finishingDate, eventStartingTime,
                      eventFinishingTime, _value, lat, lon)));
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
  void _onChanged2(bool value){
    setState(() {
      _value2 = value;
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
      else
        try{

          DatabaseReference Ref = FirebaseDatabase.instance.reference() ;
          var eventID = Ref.child('Events').child(eventIndex).update(
              {
                "Starting Time" : eventStartingTime.millisecondsSinceEpoch, "Finishing Time" : eventFinishingTime.millisecondsSinceEpoch
                , "Starting Date" : startingDate.millisecondsSinceEpoch, "Finishing Date" : finishingDate.millisecondsSinceEpoch
                , "Accessability" : _value, "AdminID" : globalUserId, "Occur" : occur , "Lat" : _pendingMarker.options.position.latitude
                , "Lng" : _pendingMarker.options.position.longitude,
                "Event Name": myController.text
              }

          );

          // I Need to add the event to the event list in the user
          // Ref.child('Users').child(globalUserId).child('Event_Ids').setPriority(eventKey) ;


          success = true ;

        }catch(e){
          print(e.message);
        }


    }
  }

  void initState()
  {
    super.initState();

    _tags1.addAll([
      Tag(
        id: 1,// optional
        //icon: Icons.access_time, // optional
        title: 'S', // required
        active: false, // optional
      ),
      Tag(
        id: 1,// optional
        //icon: Icons.access_time, // optional
        title: 'M', // required
        active: false, // optional
      ),
      Tag(
        id: 1,// optional
        //icon: Icons.access_time, // optional
        title: 'T', // required
        active: false, // optional
      ),
      Tag(
        id: 1,// optional
        //icon: Icons.access_time, // optional
        title: 'W', // required
        active: false, // optional
      ),
      Tag(
        id: 1,// optional
        //icon: Icons.access_time, // optional
        title: 'T', // required
        active: false, // optional
      ),
      Tag(
        id: 1,// optional
        //icon: Icons.access_time, // optional
        title: 'F', // required
        active: false, // optional
      ),
      Tag(
        id: 1,// optional
        //icon: Icons.access_time, // optional
        title: 'S', // required
        active: false, // optional
      )
    ]
    );
  }

  void _getTags() {
    _tags.forEach((tag) => print(tag));
  }



}

