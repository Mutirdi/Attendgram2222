import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class homeTab extends StatefulWidget {
  @override
  _homeTabState createState() => new _homeTabState();
}

class _homeTabState extends State<homeTab> {
  StreamSubscription _subscriptionTodo;

  String _fname = "Display the first name here";
  String _lname = "Display the last name here";

  @override
  void initState() {
    FirebaseTodos.getTodoStream("1", _updateUser)
        .then((StreamSubscription s) => _subscriptionTodo = s);
    super.initState();
  }

  @override
  void dispose() {
    if (_subscriptionTodo != null) {
      _subscriptionTodo.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var itemTile = new ListTile(
      title: new Text("$_fname , $_lname"),
    );

    return new Scaffold(
      body: new ListView(
        children: <Widget>[
          itemTile,
        ],
      ),
    );
  }


  _updateUser(User value) {
    var fname = value.fname;
    var lname = value.lname;
    setState((){
      _fname = fname;
      _lname = lname;
    });
  }
}





class User {
  final String key;
  String fname;
  String lname;

  User.fromJson(this.key, Map data) {
    fname = data['fname'];
    lname = data['lname'];
    if (fname == null) {
      fname = '';
    }
    if (lname == null){
      lname = '' ;
    }
  }
}





class FirebaseTodos{

  static Future<StreamSubscription<Event>> getTodoStream(String key,
      void onData(User user)) async {
    String accountKey = await Preferences.getAccountKey();

    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("User")
        .child(accountKey)
        .onValue
        .listen((Event event) {
      var user = new User.fromJson(event.snapshot.key, event.snapshot.value);
      onData(user);
    });

    return subscription;
  }

  /// FirebaseTodos.getTodo("-KriJ8Sg4lWIoNswKWc4").then(_updateTodo);
  static Future<User> getTodo(String todoKey) async {
    Completer<User> completer = new Completer<User>();

    String accountKey = await Preferences.getAccountKey();
    print("//////////////////////////");
    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(accountKey)
        .once()
        .then((DataSnapshot snapshot) {
      var user = new User.fromJson(snapshot.key, snapshot.value);
      completer.complete(user);
    });

    print(completer.future);
    return completer.future;
  }
}






class Preferences {
  static const String ACCOUNT_KEY = "accountKey";

  static Future<bool> setAccountKey(String accountKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ACCOUNT_KEY, accountKey);
    return prefs.commit();
  }

  static Future<String> getAccountKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountKey = prefs.getString(ACCOUNT_KEY);

    // workaround - simulate a login setting this
    if (accountKey == null) {
      accountKey = "1";
    }
    print("/////////////////////////////////");
    print(accountKey);
    return accountKey;
  }
}