
import 'package:flutter/material.dart';
import 'globals.dart';
import 'DB_Calls.dart';
import 'UpdateProfile.dart';
import 'login.dart';
import 'package:flutter_tags/selectable_tags.dart';


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
  static String tag = 'view-account-page';


  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  String username , description ;
  List<Tag> _tags1=[];

//  @override
//  void initState() {
//    build(context);
//  }

  void initState() {
      setState(() {
        int i=0;
        for(i=0; i < currentUserinterests.length; i++) {
          print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
          print(currentUserinterests[i]);
          _tags1.addAll([
            Tag(
              id: 1, // optional
              //icon: Icons.access_time, // optional
              title: currentUserinterests[i], // required
              active: false, // optional
            ),
          ]
          );
        }
      });


  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                  icon: const Icon(Icons.menu,color: Color(0xFF18D191)),
                  iconSize: 25.0

              );
            },
          ),

          title: new Text('Profile',style: new TextStyle(
              fontSize: 25.0,
              color: Color(0xFF18D191) )),
          centerTitle: true,
          backgroundColor:Colors.transparent,
          elevation: 0.0,
            actions: <Widget>[
        IconButton(
        icon: Icon(Icons.edit,size: 25.0,color: Colors.black),
        onPressed:  () {
           Navigator.push(context, MaterialPageRoute(
              builder: (context) => EditProfile(),
           ));

    },

    ),

    ],
        ),


        drawer: new Drawer(

            child: new ListView(

              children: <Widget>[
                SizedBox(height: 20.0),
                new UserAccountsDrawerHeader(

                  decoration: new BoxDecoration(
                   //   color: Color(0xFF18D191)
                  ),
                  accountName: new Text('$currentUserName',style: TextStyle(fontSize: 25.0, color: Colors.black),),
                  accountEmail: new Text("smahmood@gmail.com",style: TextStyle(color: Colors.black54)),
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

        body:new Stack(

          alignment: Alignment.center,


          children: <Widget>[


            Positioned(



                child: ListView(
                  padding: EdgeInsets.only(left: 25.0, right: 30.0),
                  //shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(height: 60.0),
                    Column(children: <Widget>[
                      new Container(
                          width: 90.0,
                          height: 90.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                    imageUrl.toString(),)
                              )
                          )),
                      Text(
                        '$currentUserName',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ],
                    ),

                    SizedBox(height: 40.0),

                Row(children: <Widget>[
                  Text(
                    'Info',
                    style: TextStyle(color: Colors.black,fontSize: 25.0,fontWeight: FontWeight.bold,),

                  ),
                ],),

                //SizedBox(height: 35.0),
                new Divider(height: 20.0,),


                SizedBox(height: 15.0),
                Text(
                  '$currentUserDescripition',

                  style: TextStyle(fontSize: 18.0, color: Colors.black54 ),
                ),

                    SizedBox(height: 25.0),

                    Text(
                      'Interests: ',
                      style: TextStyle(color: Colors.black54,fontSize: 18.0),
                    ),
                    SelectableTags(
                      tags: _tags1,
                      color: Colors.white,
                      activeColor: Color(0xFF18D191),
                      //columns: 4, // default 4
                      //symmetry: true, // default false
                      alignment: MainAxisAlignment.center,
                      onPressed: (tag){
                        print(tag);
                      },
                    ),

                    SizedBox(height: 25.0),

                    FlatButton(

                      textColor:  Color(0xFF18D191),
                      child: const Text('Settings'),
                      //onPressed: _selectStartingTime,
                    ),
                    FlatButton(

                      textColor:  Color(0xFF18D191),
                      child: const Text('Privacy Policy'),
                      //onPressed: _selectStartingTime,
                    ),
                    FlatButton(

                      textColor:  Color(0xFF18D191),
                      child: const Text('Terms and Conditions'),
                      //onPressed: _selectStartingTime,
                    ),
                    FlatButton(

                      textColor:  Color(0xFF18D191),
                      child: const Text('About'),
                      //onPressed: _selectStartingTime,
                    ),

                    SizedBox(height: 15.0),
                    /*
                    new Container(
                      margin: const EdgeInsets.all(1.0),
                      padding: const EdgeInsets.fromLTRB(12.0,5.0,2.0,50.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.blue)
                      ),
                      child: new Text("$currentUserDescripition",textAlign: TextAlign.left),

                    ),
                    */
                    /*
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
                                minWidth: 340.0,
                                height: 42.0,
                                onPressed:() {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => editProfile()));
                                },
                                color: Colors.lightBlue,
                                child: Text('Edit Profile',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    */
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 50.0, right: 50.0, top: 20.0),

                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 25.0),
                  ],
                )
            )
          ],

        )

    );
  }

  void _getTags() {
    _tags1.forEach((tag) => print(tag));
  }





}