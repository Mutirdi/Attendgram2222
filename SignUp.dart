import 'package:firebase_auth/firebase_auth.dart';
import 'home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'globals.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class SignUp extends StatefulWidget {

  @override
  _SignUpState createState() => new _SignUpState();
}

class _SignUpState extends State<SignUp> {


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password,_UserName,_descripition;


  DatabaseReference Ref;
  FirebaseUser user;
  File sampleImage;





  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
  }


  Future getImage() async {
    var tempImage  = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 100.0, maxHeight: 150.0);

    setState(() {
      sampleImage = tempImage;
    });
  }



  @override
  Widget build(BuildContext context) {






    final photoIcon = Icon(Icons.add_a_photo);

    return new Scaffold(

      appBar: new AppBar(
          backgroundColor:Colors.transparent,
          elevation: 0.0,


      ),

      backgroundColor: Color(0xFF18D191),


      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            shrinkWrap: true,
            children: <Widget>[


              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      "CREATE ACCOUNT",
                      style: new TextStyle(fontSize: 30.0,color: Colors.white),

                    ),
                  )
                ],
              ),

              SizedBox(height: 25.0),
              Row(
                  children: [

              new FloatingActionButton(


                child: new Icon(Icons.add_a_photo),
                foregroundColor: Colors.green,
                backgroundColor: Colors.white,
                tooltip: 'Add Image',
                onPressed: getImage,

              ),
              new Container(

                child: sampleImage == null ? Text('') : enableUpload(),
              ),
    ],//
              ),
              SizedBox(height: 24.0),
              Text(
                'User Name: ',
                style: TextStyle(color: Colors.white),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person_outline),
                  hintText: 'What is your name?',

                ),
                style: TextStyle(color: Colors.white),
                onSaved: (input) => _UserName = input,
              ),

              SizedBox(height: 24.0),
              Text(
                'Email: ',
                style: TextStyle(color: Colors.white),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.alternate_email),
                  hintText: 'What is your email?',

                ),
                style: TextStyle(color: Colors.white),
                onSaved: (input) => _email = input,
              ),
              SizedBox(height: 24.0),
              Text(
                'Password: ',
                style: TextStyle(color: Colors.white),
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.visibility_off),
                  hintText: 'What is your password?',

                ),
                style: TextStyle(color: Colors.white),
                onSaved: (input) => _password = input,
              ),
              SizedBox(height: 24.0),
              Text(
                'Description: ',
                style: TextStyle(color: Colors.white),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.description),
                  hintText: 'Descripe yourself!',

                ),
                style: TextStyle(color: Colors.white),
                onSaved: (input) => _descripition = input,
              ),



              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(

                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0),
                      child: GestureDetector(
                        //onTap: () {
                        //Navigator.push(context, MaterialPageRoute(
                        // builder: (context) => LoginPage(),
                        //));
                        //},
                        onTap: SignUP,
                        child: new Container(
                            alignment: Alignment.center,
                            height: 60.0,
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(15.0)),
                            child: new Text("Sign Up",

                                style: new TextStyle(
                                    fontSize: 25.0,
                                    color: Color(0xFF18D191) ))),
                      ),
                    ),
                  )
                ],
              ),


            ],
          )
      ),
    );

  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[

          Image.file(sampleImage, height: 100.0, width: 100.0 ,fit: BoxFit.contain),
        ],
      ),
    );
  }


  void SignUP() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
     var UserId =user.uid;
        final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(UserId);
        final StorageUploadTask task =
        firebaseStorageRef.putFile(sampleImage);

        Ref = FirebaseDatabase.instance.reference();

        userEntry newuser= userEntry(_UserName,_email,_descripition);

        Ref.child('Users').setPriority(user.uid);
        Ref.child('Users').child(user.uid).set(newuser.toJson());

        _accountCreated();

      }catch(e){
        _errorOccurred(e.message);
        print(e.message);

      }
    }
  }

  Future<void> _accountCreated() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account Created'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Account Created Succesfully'),

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

  Future<void> _errorOccurred(String e) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error Occurred'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(e),

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





class userEntry {

  String Name;
  String email;
  String descripition;


  userEntry(this.Name,this.email,this.descripition);

  toJson() {
    return {

      "Name": Name,
      "descrption": descripition,
      "email": email,
      "Event_Ids":'',
      "Event_Admin":'',
      'interests':"",



    };
  }
}