
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
import 'View_Account.dart';





class EditProfile extends StatefulWidget {
  static String tag = 'login-page';
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
  @override
  _EditProfileState createState() => new _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GoogleMapController mapController;
  final LatLng center = const LatLng(45.521563, -122.677433);
  bool firstTimeMap = true;

  List<String> _tags = [];
  List<Tag> _tags1 = [];
  DatabaseReference Ref;

  bool _value = false;
  bool _value2 = false;
  List<bool> occur = [false, false, false, false, false, false, false];
  String _eventName;

  String FinishingDateText = "Select Finishing Date",
      StartingDateText = "Select Starting Date",
      FinishingTimeText = "Select Finishing Time",
      StartingTimeText = "Select Starting Time";
  DateTime startingDate, finishingDate;

  DateTime eventStartingTime, eventFinishingTime;

  var success = false;

  var _volume = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Color(0xFF18D191)),

        title: new Text('Edit', style: new TextStyle(
            fontSize: 25.0,
            color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done, size: 25.0, color: Color(0xFF18D191)),
            onPressed:editProfile1,
          ),
        ],
      ),

      backgroundColor: Colors.white,


      body: Form(

        key: _formKey,
        child: ListView(

            padding: EdgeInsets.only(left: 30.0, right: 30.0),

            children: <Widget>[

              SizedBox(height: 40.0),


              Row(children: <Widget>[
                Text(
                  'Info',
                  style: TextStyle(color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,),

                ),
              ],),

              //SizedBox(height: 35.0),
              new Divider(height: 20.0,),


              Text(
                'Profile Pic: ',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 5.0),
              Row(children: <Widget>[
                Image.asset(

                  'assets/images/Profile2.png',
                  height: 70,
                  width: 70,

                ),
              ],
              ),
              SizedBox(height: 20.0),
              Text(
                'User Name: ',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 5.0),
              TextFormField(
                keyboardType: TextInputType.text,
                autofocus: false,
                validator: (val) =>
                val.isEmpty
                    ? 'Event name can\'t be empty.'
                    : null,
                decoration: InputDecoration(
                  counterText: "100",
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  hintText: 'Ex: Omar Abdullah',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                onSaved: (input) => currentUserName = input,
              ),

              SizedBox(height: 20.0),
              Text(
                'User Bio: ',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 5.0),
              TextFormField(
                keyboardType: TextInputType.text,
                autofocus: false,
                validator: (val) =>
                val.isEmpty
                    ? 'Event name can\'t be empty.'
                    : null,

                decoration: InputDecoration(
                  counterText: "100",
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  hintText: 'Ex: KFUPMer,Senior Student... ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),),

                ),
                onSaved: (input) => currentUserDescripition = input,
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
                onDelete: (tag) {
                  print(tag);
                },
                onInsert: (tag) {
                  print(tag);
                },
              ),


            ]
        ),
      ),
    );
  }
  void editProfile1() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Ref = FirebaseDatabase.instance.reference();
        //userCall();
        editProfile editedProfile = editProfile(currentUserName, currentUserDescripition, _tags);
        print("#################################### mahmoud ");
        currentUserinterests=_tags;
        Ref.child('Users').child(globalUserId).update(editedProfile.toJson());
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyHomePage()));
      } catch (e) {
        print(e.message);
      }
    }
  }

}

class editProfile {

  String Name;
  List<String> interests;
  String descripition;
  editProfile(this.Name, this.descripition, this.interests);

  toJson() {
    return {

      "Name": Name,
      "descrption": descripition,
      "interests": interests,
    };
  }
}