//import 'dart:html';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fundoo_notes_app/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import { query, orderBy, limit } from "firebase/firestore";
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:path/path.dart';
//import 'globals.dart' as globals;
//import 'login.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

List allLable = [];

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GoogleSignIn _googleSignIn = GoogleSignIn();

  bool checkListOrGride = false;
  List allNotesData = [];

  String? sharedPreferenceEmail;
  String profileImagePath = "";
  String profileImageUpdateId = "";
  var userDocumentId;
  late Color _color = Colors.white;
  //late Color _colors;

  ////
  ///
  ///
  // List<DocumentSnapshot> _notes = [];
  bool loadingProducts = false;
  DocumentSnapshot? lastDocument;
  ScrollController scrollController = ScrollController();
  bool gettingMoreProducts = false;
  bool moreProductsAvailable = true;
  bool checkProfileImage = false;
  int limitPerPage = 10;
  late File profileImage;
  String fileName = '';

  ///
  ///
  bool isFetchingNotes = true;

  //List allLable = [];
  Future<void> getLables() async {
    allLable.clear();
    Query collectionReference = FirebaseFirestore.instance.collection('lable');
    QuerySnapshot querySnapshot = await collectionReference.get();
    final allLables = querySnapshot.docs.map((data) => data.data()).toList();
    print('sssssssssssssssssssssssssssssssssssssssssssssssssssss');
    print(allLables);
    querySnapshot.docs.forEach((allLables) {
      var map = {'lable': allLables['lable']};
      // setState(() {
      //  var allLable;
      allLable.add(map);
      // });
    });
    print('...........');
    print(allLable);
    // searchLable = allLable;
  }

  // Fetch data from firebase
  Future<void> getProfileImagePath() async {
    Query collectionReference = FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: sharedPreferenceEmail);
    QuerySnapshot querySnapshot = await collectionReference.get();
    final notesAllData = querySnapshot.docs.map((data) => data.data()).toList();
    print('sssssssssssssssssssssssssssssssssssssssssssssssssssss');
    print(notesAllData);
    print(sharedPreferenceEmail);

    querySnapshot.docs.forEach((notesAllData) {
      if (notesAllData['email'] == sharedPreferenceEmail) {
        print(notesAllData['profileImage']);
        setState(() {
          profileImagePath = notesAllData['profileImage'];
          profileImageUpdateId = notesAllData.id;
        });
      }
    });
    print(profileImagePath);
  }

  Future<void> getNotesData() async {
    final prefs = await SharedPreferences.getInstance();
    sharedPreferenceEmail = prefs.getString('email')!;
    //var url = prefs.getString('profileImagePath')!;
    // print(url);
    // setState(() {
    //   profileImagePath = url;
    //   print(profileImagePath);
    // });

    Query collectionReference = FirebaseFirestore.instance
        .collection('notes')
        .orderBy("title", descending: true)
        .limit(limitPerPage)
        .where("trash", isEqualTo: false)
        .where("archived", isEqualTo: false)
        .where("email", isEqualTo: sharedPreferenceEmail);
    //.limit(8);
    //.orderBy("title", descending: true);
    //.orderBy("title");
    setState(() {
      loadingProducts = true; /////////
    });
    // loadingProducts = true; /////////
    QuerySnapshot querySnapshot = await collectionReference.get();
    // _notes = querySnapshot.docs;
    print('........');
    if (querySnapshot.docs.length > 0) {
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    }
    print(lastDocument);
    if (querySnapshot.docs.length < limitPerPage) {
      moreProductsAvailable = false;
    }

    ///

    final notesAllData = querySnapshot.docs.map((data) => data.data()).toList();
    print(
        '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    print(notesAllData);
    //notesAllData.sort();
    querySnapshot.docs.forEach((notesAllData) {
      var map = {
        'email': notesAllData['email'],
        'firstName': notesAllData['firstName'],
        'color': notesAllData['color'],
        'note': notesAllData['note'],
        'title': notesAllData['title'],
        'pin': notesAllData['pin'],
        'archived': notesAllData['archived'],
        'id': notesAllData.id
      };
      setState(() {
        allNotesData.add(map);
        // allNotesData.sort();
        // allNotesData = allNotesData.reversed.toList();
      });
      print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
      print(allNotesData);
    });
    print(allNotesData);
    setState(() {
      // allNotesData.map.keys.toList()..sort();
      // allNotesData.sort((a, b) => a.compareTo(b));
      loadingProducts = false;
    });
  }

  getMoreNotesData() async {
    isFetchingNotes = false;

    Query collectionReference = FirebaseFirestore.instance
        .collection('notes')
        .orderBy("title", descending: true)
        //.orderBy("note", descending: true)

        //  .orderBy('email')
        .limit(limitPerPage)
        .startAfterDocument(lastDocument!)
        .where("trash", isEqualTo: false)
        .where("archived", isEqualTo: false)
        .where("email", isEqualTo: sharedPreferenceEmail);
    // .limit(8);
    // .orderBy("title", descending: true)

    QuerySnapshot querySnapshot = await collectionReference.get();
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    print(querySnapshot.docs.length);
    if (querySnapshot.docs.length < 8) {
      moreProductsAvailable = false;
      isFetchingNotes = false;
    }
    if (querySnapshot.docs.length > 0) {
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    }

    ///

    final notesAllData = querySnapshot.docs.map((data) => data.data()).toList();
    print(
        '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    print(notesAllData);

    querySnapshot.docs.forEach((notesAllData) {
      var map = {
        'email': notesAllData['email'],
        'firstName': notesAllData['firstName'],
        'color': notesAllData['color'],
        'note': notesAllData['note'],
        'title': notesAllData['title'],
        'pin': notesAllData['pin'],
        'archived': notesAllData['archived'],
        'id': notesAllData.id
      };
      // print('more ,,,,,,,,');
      // print(map);
      setState(() {
        allNotesData.add(map);
        //allNotesData.sort();
        // allNotesData = allNotesData.reversed.toList();
      });
      print("''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''");
      print(allNotesData);
    });
    print(allNotesData);
    // setState(() {
    //   gettingMoreProducts = false;
    // });
    if (querySnapshot.docs.length == limitPerPage) {
      isFetchingNotes = true; ////////
    }
    // isFetchingNotes = false;
  }

  void getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    print(image);
    if (image != null) {
      setState(() {
        profileImage = File(image.path);
        fileName = profileImage.path.split('/').last;
        //  fileName = basename(profileImage.path);
        userDocumentId = prefs.getString('profileImageId');
        if (prefs.getString('profileImageId') != "") {
          upLoadImageToFirebase();
        }
      });
      setState(() {
        checkProfileImage = true;
      });
    }
  }

  upLoadImageToFirebase() async {
    final prefs = await SharedPreferences.getInstance();

    Reference storageRefrence = FirebaseStorage.instance.ref().child(fileName);
    final UploadTask uploadTask = storageRefrence.putFile(profileImage);
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    print('///////////////////////////////////////////////');
    print(url);
    print(prefs.getString('profileImageId'));

    FirebaseFirestore.instance
        .collection("users")
        .doc(prefs.getString('profileImageId'))
        .update({"profileImage": url});
    // getProfileImagePath();
    if (profileImagePath != "") {
      FirebaseStorage.instance.refFromURL(profileImagePath).delete();
    }
    setState(() {
      //  var tempPath = url;
      profileImagePath = url;
    });
  }

  @override
  void initState() {
    super.initState();
    getNotesData();
    getProfileImagePath();
    getLables();

    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if (maxScroll - currentScroll <= delta) {
        print('================================================');
        if (moreProductsAvailable && isFetchingNotes) {
          getMoreNotesData();
        }
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: Text(notification.body.toString()),
              );
            });
      }
    });
  }

  void showNotification() {
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing",
        "How are your ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: drawer(),
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white10,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(22),
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 12),
              height: 52,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 1.0,
                    )
                  ]),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 30,
                      ),
                      onPressed: () {
                        //Scaffold.of(context).openEndDrawer();
                        _scaffoldKey.currentState?.openDrawer();
                      }),
                  SizedBox(
                    width: 0,
                  ),
                  Expanded(
                    // child: TextField(
                    //   decoration: InputDecoration.collapsed(
                    //     hintText: "Search your notes",
                    //   ),
                    //   onChanged: (value) {},
                    // ),
                    child: InkWell(
                      child: Text('Search your notes'),
                      onTap: () {
                        Navigator.pushNamed(context, '/searchNotes');
                      },
                    ),
                  ),
                  SizedBox(
                    width: 55,
                  ),
                  IconButton(
                    icon: checkListOrGride
                        ? Icon(Icons.view_agenda_outlined)
                        : Icon(Icons.grid_view_outlined),
                    onPressed: () {
                      setState(() {
                        checkListOrGride = !checkListOrGride;
                      });
                    },
                  ),
                  IconButton(
                      icon: CircleAvatar(
                        backgroundColor: Colors.grey[400],
                        radius: 15,
                        backgroundImage: profileImagePath != ""
                            ? NetworkImage("$profileImagePath")
                            : null,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 200,
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        child: Container(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              iconSize: 50,
                                              onPressed: () {},
                                              icon: CircleAvatar(
                                                backgroundColor:
                                                    Colors.grey[400],
                                                radius: 30,
                                                backgroundImage:
                                                    profileImagePath != ""
                                                        ? NetworkImage(
                                                            "$profileImagePath")
                                                        : null,
                                                // child: checkProfileImage
                                                //     ? Image.file(
                                                //         profileImage,
                                                //         fit: BoxFit.scaleDown,
                                                //       )
                                                //     : Image.asset(
                                                //         "assets/images/note_images.jpeg"),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            IconButton(
                                                iconSize: 30,
                                                onPressed: () {
                                                  getProfileImage();
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.edit))
                                          ],
                                        )),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(sharedPreferenceEmail.toString())
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  SharedPreferences
                                                      preferences =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  await preferences.clear();
                                                  _googleSignIn
                                                      .signOut()
                                                      .then((value) => {})
                                                      .catchError((e) {});
                                                  Navigator.pushNamed(
                                                      context, '/login');
                                                },
                                                child: Text('Log Out')),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });

////////////////////////////
                      }),
                ],
              ),
            ),
          ),
        ),
        body: allNotesData.isEmpty
            ? Center(child: CircularProgressIndicator())
            // : loadingProducts == true
            // ? Center(child: CircularProgressIndicator())
            : checkListOrGride
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      controller: scrollController,
                      itemCount: allNotesData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2),
                      itemBuilder: (BuildContext context, int index) {
                        _color = Colors.white;
                        print('???????????????????????????????????????????');
                        print(allNotesData[index]['color']);
                        if (allNotesData[index]['color'] != "") {
                          print('/////////////');
                          String valueString = allNotesData[index]['color']
                              .toString()
                              .split('(0x')[1]
                              .split(')')[0];
                          int value = int.parse(valueString, radix: 16);
                          Color otherColor = new Color(value);
                          _color = otherColor;
                          print(_color);
                        }
                        return Padding(
                          padding: const EdgeInsets.only(),
                          child: InkWell(
                            onTap: () {
                              print(allNotesData[index]);
                              Navigator.pushNamed(context, '/updateNotes',
                                  arguments: {
                                    'email': allNotesData[index]['email'],
                                    'firstName': allNotesData[index]
                                        ['firstName'],
                                    'color': allNotesData[index]['color'],
                                    'note': allNotesData[index]['note'],
                                    'title': allNotesData[index]['title'],
                                    'id': allNotesData[index]['id'],
                                    'pin': allNotesData[index]['pin'],
                                    'archived': allNotesData[index]['archived'],
                                    'rootSource': 'home'
                                  });
                            },
                            child: Card(
                              color: _color,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: SingleChildScrollView(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          allNotesData[index]['title'],
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(allNotesData[index]['note'],
                                            style: TextStyle(
                                              fontSize: 15,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : ListView.builder(
                    controller: scrollController, ////
                    //  reverse: false,
                    itemCount: allNotesData.length,
                    itemBuilder: (BuildContext context, int index) {
                      _color = Colors.white;
                      print('???????????????????????????????????????????');
                      print(allNotesData[index]['color']);
                      if (allNotesData[index]['color'] != "") {
                        print('/////////////');
                        String valueString = allNotesData[index]['color']
                            .toString()
                            .split('(0x')[1]
                            .split(')')[0];
                        int value = int.parse(valueString, radix: 16);
                        Color otherColor = new Color(value);
                        _color = otherColor;
                        print(_color);
                      }
                      // if (allNotesData[index]['color'] != "") {
                      //   String valueString = allNotesData[index]['color']
                      //       .toString()
                      //       .split('Color(0x')[1]
                      //       .split(')')[0];
                      //   int value = int.parse(valueString, radix: 16);
                      //   Color otherColor = new Color(value);
                      //   setState(() {
                      //     _colors = otherColor;
                      //   });
                      // } else {
                      //   setState(() {
                      //     _colors = Colors.white;
                      //   });
                      // }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 10),
                        child: InkWell(
                          onTap: () {
                            //   print(allNotesData[index]);
                            Navigator.pushNamed(context, '/updateNotes',
                                arguments: {
                                  'email': allNotesData[index]['email'],
                                  'firstName': allNotesData[index]['firstName'],
                                  'color': allNotesData[index]['color'],
                                  'note': allNotesData[index]['note'],
                                  'title': allNotesData[index]['title'],
                                  'pin': allNotesData[index]['pin'],
                                  'archived': allNotesData[index]['archived'],
                                  'id': allNotesData[index]['id'],
                                  'rootSource': 'home'
                                });
                          },
                          child: Card(
                              elevation: 0,
                              color: _color,
                              // new Color(allNotesData[index]['color']),
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.black12, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allNotesData[index]['title'],
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      allNotesData[index]['note'],
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ))),
                        ),
                      );
                    }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Builder(
              builder: (context) => IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addNotes');
                  },
                  icon: Image.asset("assets/images/addIcon.png"))),
          foregroundColor: Colors.amber,
          focusColor: Colors.white10,
          hoverColor: Colors.green,
          backgroundColor: Colors.white,
          splashColor: Colors.tealAccent,
        ),
        bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: Colors.white,
            child: Container(
              width: 80,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.check_box_outlined,
                        size: 25,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(
                        Icons.brush_outlined,
                        size: 25,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      onPressed: () {
                        showNotification();
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.mic,
                        size: 25,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(
                        Icons.crop_original,
                        size: 25,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      onPressed: () {}),
                ],
              ),
            )));
  }
}

// Drawer
class drawer extends StatelessWidget {
  const drawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
            child: Center(
                child: Text(
          'Keep Notes',
          style: TextStyle(fontSize: 35, color: Colors.yellow[700]),
        ))),
        // ListTile(
        //   title: Text(
        //     'Keep Notes',
        //     style: TextStyle(fontSize: 24),
        //   ),
        // ),
        SizedBox(
          height: 10,
        ),
        ListTile(
          leading: Icon(
            Icons.lightbulb_outline,
            size: 20,
          ),
          title: Text(
            'Notes',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        ListTile(
          leading: Icon(
            Icons.add_alert,
            size: 20,
          ),
          title: Text(
            'Reminders',
            style: TextStyle(fontSize: 20),
          ),
        ),
        if (allLable.length != 0)
          ListTile(
            leading: Text(
              'Create new lable',
              style: TextStyle(fontSize: 15),
            ),
            trailing: Text('EDIT', style: TextStyle(fontSize: 15)),
            onTap: () {
              Navigator.pushNamed(context, '/editLable');
            },
          ),
//
        new Expanded(
          flex: 1,
          child: ListView.builder(
              physics: ScrollPhysics(),
              //  physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: allLable.length,
              itemBuilder: (BuildContext context, int index) {
                // var value;
                return Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.label_outline),
                      SizedBox(width: 30),
                      Text(
                        allLable[index]['lable'],
                        style: TextStyle(fontSize: 14),
                      ),
                      // Expanded(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     //crossAxisAlignment: CrossAxisAlignment.end,
                      //     children: [
                      //       //new Spacer(),
                      //       Checkbox(
                      //         value: this.checkboxValue,
                      //         onChanged: (bool? value) {
                      //           setState(() {
                      //             this.checkboxValue = value!;
                      //           });
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                );
              }),
        ),
        //
        ListTile(
          leading: Icon(
            Icons.add,
            size: 20,
          ),
          title: Text(
            'Create new lable',
            style: TextStyle(fontSize: 20),
          ),
        ),
        ListTile(
            leading: Icon(
              Icons.archive_outlined,
              size: 20,
            ),
            title: Text(
              'Archive',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/archived');
            }),
        ListTile(
          leading: Icon(
            Icons.delete_sharp,
            size: 20,
          ),
          title: Text(
            'Trash',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/trash');
          },
        ),
      ],
    ));
  }
}
