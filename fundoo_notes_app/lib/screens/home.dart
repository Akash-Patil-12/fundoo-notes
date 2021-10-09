import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import { query, orderBy, limit } from "firebase/firestore";

//import 'login.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GoogleSignIn _googleSignIn = GoogleSignIn();

  bool checkListOrGride = false;
  List allNotesData = [];
  String? sharedPreferenceEmail;
  ////
  ///
  ///
  List<DocumentSnapshot> _notes = [];
  bool loadingProducts = false;
  DocumentSnapshot? lastDocument;
  ScrollController scrollController = ScrollController();
  bool gettingMoreProducts = false;
  bool moreProductsAvailable = true;

  ///
  ///
  bool isFetchingNotes = true;

// Fetch data from firebase
  Future<void> getNotesData() async {
    final prefs = await SharedPreferences.getInstance();
    sharedPreferenceEmail = prefs.getString('email')!;

    Query collectionReference = FirebaseFirestore.instance
        .collection('notes')
        .orderBy("title", descending: true)
        .limit(13)
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
    if (querySnapshot.docs.length < 8) {
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
    // if (isFetchingNotes == false) {
    //   return;
    // }
    isFetchingNotes = false;
    // print("getmorenotes");
    // if (moreProductsAvailable == false) {
    //   print('moreproductsavailable');
    //   return;
    // }
    // if (gettingMoreProducts == true) {
    //   print('gettingmoreproducts');
    //   return;
    // }
    // gettingMoreProducts = true;
    // final prefs = await SharedPreferences.getInstance();
    // sharedPreferenceEmail = prefs.getString('email')!;

    Query collectionReference = FirebaseFirestore.instance
        .collection('notes')
        .orderBy("title", descending: true)
        //.orderBy("note", descending: true)

        //  .orderBy('email')
        .limit(13)
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
    if (querySnapshot.docs.length == 8) {
      isFetchingNotes = true; ////////
    }
    // isFetchingNotes = false;
  }

  @override
  void initState() {
    super.initState();
    getNotesData();

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
          //brightness: Brightness.light,
          //foregroundColor: Colors.black,
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
                      ),
                      onPressed: () {
                        // bool checkRoute = false;
                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         title: CircleAvatar(
                        //           backgroundColor: Colors.grey[400],
                        //         ),
                        //         content: Text(sharedPreferenceEmail.toString()),
                        //         actions: <Widget>[
                        //           ElevatedButton(
                        //               onPressed: () async {
                        //                 SharedPreferences preferences =
                        //                     await SharedPreferences
                        //                         .getInstance();
                        //                 await preferences.clear();
                        //                 _googleSignIn
                        //                     .signOut()
                        //                     .then((value) => {})
                        //                     .catchError((e) {});
                        //                 checkRoute = true;
                        //                 if (checkRoute) {
                        //                   Navigator.pushNamed(
                        //                       context, "/login");
                        //                 }
                        //                 Navigator.pop(context, 'Log Out');
                        //                 //Navigator.push(
                        //                 //     context,
                        //                 //   pushNamed(context, '/login'));
                        //               },
                        //               child: Text('Log Out')),
                        //         ],
                        //       );
                        //     });

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
                                                  radius: 50,
                                                )),
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
                                    'rootSource': false
                                  });
                            },
                            child: Card(
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
                                  'rootSource': false
                                });
                          },
                          child: Card(
                              elevation: 0,
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
                      onPressed: () {}),
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
