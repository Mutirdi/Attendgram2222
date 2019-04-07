
import 'package:firebase_auth/firebase_auth.dart';
import 'home_widget.dart';
import 'SignUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_widget.dart';
import 'SignUp.dart';
import 'package:flutter/material.dart';
import 'globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'myData.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  DatabaseReference Ref;
  Map<dynamic,dynamic> map ;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFF18D191),

      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 150.0),
              Image.asset(

                'assets/images/NewLogo.png',
                height: 200,
                width: 75,

                alignment: Alignment.center,



              ),

              SizedBox(height: 35.0),
              Text(
                'Email: ',
                style: TextStyle(color: Colors.white),
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person_outline),
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
                validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.visibility_off),
                  hintText: 'What is your password?',

                ),
                style: TextStyle(color: Colors.white),
                obscureText: true,
                onSaved: (input) => _password = input,
              ),
              /*
              TextFormField(

                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,

                decoration: InputDecoration(
                  hintText: 'Email',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
                onSaved: (input) => _email = input,
              ),
              SizedBox(height: 15.0),
              TextFormField(
                autofocus: false,

                obscureText: true,
                validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
                decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
                onSaved: (input) => _password = input,
              ),*/

              SizedBox(height: 80.0),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0),
                      child: GestureDetector(
                        //onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                        //},
                        onTap: signIn,
                        child: new Container(
                            alignment: Alignment.center,
                            height: 60.0,
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(15.0)),
                            child: new Text("Log In",

                                style: new TextStyle(
                                    fontSize: 25.0,
                                    color: Color(0xFF18D191) ))),
                      ),
                    ),
                  )
                ],
              ),
/*
              SizedBox(height: 30.0),
              Center(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(

                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(30.0),
                        shadowColor: Colors.lightBlue.shade100,
                        //elevation: 5.0,

                        child: MaterialButton(
                          minWidth: 330.0,
                          height: 42.0,
                          onPressed: signIn,
                          color: Colors.lightBlue,
                          child: Text('SignIn', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.0),
              Center(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(

                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(30.0),
                        shadowColor: Colors.lightBlue.shade100,
                        //elevation: 5.0,
                        child: MaterialButton(
                          minWidth: 330.0,
                          height: 42.0,
                          onPressed:() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SignUp()));
                          },
                          color: Colors.lightBlue,
                          child: Text('SignUp', style: TextStyle(color: Colors.white)),
                        ),

                      ),

                    ),

                  ],
                ),
              ),

              FlatButton(
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.black54),
                ),

              ),
              */

              FlatButton(
                  child: Text(
                    'Create Account',
                    style: TextStyle(fontSize: 17.0,color: Colors.black54),
                  ),
                  onPressed:() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  }
              ),

            ],
          )
      ),
    );
  }

  void signIn() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        globalUserId=user.uid;
        UserEmail=_email;
        Ref = FirebaseDatabase.instance.reference();

        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(user:user)));

        Ref.child('Users').child(globalUserId).once().then((DataSnapshot snap) {
          map = snap.value;
          currentUserName = map['Name'];
          currentUserDescripition = map['descrption'];
          currentUserinterests = map['interests'];
          currentEventAdmin = map['Event_Admin'];
          currentEventIDs = map['Event_Ids'] ;
          //print(currentEventIDs);



          setState(() {
          });



        });

        FirebaseStorage storage = new FirebaseStorage(
            storageBucket: 'gs://attendgram.appspot.com/'
        );
        StorageReference  imageLink = storage.ref().child(globalUserId);
         imageUrl = await imageLink.getDownloadURL();





      }catch(e){
        _errorOccurred(e.message);
        print(e.message);

      }
    }
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