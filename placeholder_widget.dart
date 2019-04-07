
import 'package:flutter/material.dart';
import 'globals.dart';

void main() => runApp(new PlaceholderWidget());

class PlaceholderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: new Stack(

          alignment: Alignment.center,


          children: <Widget>[
            Positioned(
                child: ListView(

                  children: <Widget>[
                    SizedBox(height: 100.0),
                    Image.asset(

                      'assets/images/Profile2.png',
                      height: 140,
                      width: 140,




                    ),

                    SizedBox(height: 50.0),

                    Text(
                      '$currentUserName',
                      textAlign: TextAlign.center,
                      style: TextStyle(

                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),

                    SizedBox(height: 15.0),
                    Text(
                      '$currentUserDescripition',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ),

                    SizedBox(height: 50.0),
                    Center(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(

                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(30.0),
                              shadowColor: Colors.lightBlue.shade100,
                              elevation: 5.0,
                              child: MaterialButton(
                                minWidth: 370.0,
                                height: 42.0,
                                color: Colors.lightBlue,
                                child: Text('Edit Profile', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //SizedBox(height: 10.0),
                    Center(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(

                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(30.0),
                              shadowColor: Colors.lightBlue.shade100,
                              elevation: 5.0,
                              child: MaterialButton(
                                minWidth: 370.0,
                                height: 42.0,
                                color: Colors.lightBlue,
                                child: Text('Notification', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //SizedBox(height: 10.0),
                    Center(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(

                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(30.0),
                              shadowColor: Colors.lightBlue.shade100,
                              elevation: 5.0,
                              child: MaterialButton(
                                minWidth: 370.0,
                                height: 42.0,
                                color: Colors.lightBlue,
                                child: Text('Settinges', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.0),
                  ],
                )
            )
          ],

        )

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