import 'package:flutter/material.dart';
import 'View_Account.dart';
import 'search_page.dart';
import 'homeTab.dart';
import 'Create_Event_Tab.dart';
import 'ShowDataPage.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
class Home extends StatefulWidget {
  const Home({
    Key key , this.user
  }) : super(key:key);
  final FirebaseUser user ;
  static String tag = 'home-page';
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    ShowDataPage(),
    SearchPage(),
    CreateEventTab(),
    PlaceholderWidget()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Color(0xFF18D191),
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Create Event'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}