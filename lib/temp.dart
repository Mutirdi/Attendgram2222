
import 'package:firebase_auth/firebase_auth.dart';
import 'home_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      backgroundColor: Colors.white,

      appBar: new AppBar(
        title: Text('Attendgram Login'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Image.asset(

                'assets/images/attendgram.png',
                height: 300,
                width: 250,

                alignment: Alignment.center,



              ),

              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autofocus: false,

                validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
                decoration: InputDecoration(
                  hintText: 'Email  ex:(user@gmail.com)',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
                onSaved: (input) => _email = input,

              ),
              SizedBox(height: 25.0),
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
              ),
              SizedBox(height: 25.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Colors.lightBlueAccent.shade100,
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 42.0,
                    onPressed: signIn,
                    color: Colors.lightBlueAccent,
                    child: Text('Log In', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              FlatButton(
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.black54),
                ),
                onPressed: _forgetPassword,
              ),
            ],
          )
      ),
      //resizeToAvoidBottomPadding: false
    );
  }

  void signIn() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
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
  Future<void> _forgetPassword() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset you Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You recived an email to'),
                Text('reset your password'),
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