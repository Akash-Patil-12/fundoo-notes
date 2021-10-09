import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class UpdateNotes extends StatefulWidget {
  UpdateNotes({Key? key}) : super(key: key);

  @override
  _UpdateNotesState createState() => _UpdateNotesState();
}

class _UpdateNotesState extends State<UpdateNotes> {
  late bool checkPin = false, checkArchived = true;

  Map notesData = {};
  TextEditingController title = new TextEditingController();
  TextEditingController note = new TextEditingController();

  // late String email, firstName;
  // List<String> menuOption = ['save', 'demo'];
  dynamic currentTime = DateFormat.jm().format(DateTime.now());

  // Future<void> getSharedData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   email = prefs.getString('email')!;
  //   firstName = prefs.getString('firstName')!;
  //   print(email);
  //   print(firstName);
  // }

  @override
  void initState() {
    super.initState();
    //  getSharedData();
  }

  @override
  Widget build(BuildContext context) {
    notesData = ModalRoute.of(context)!.settings.arguments as Map;
    title.text = notesData['title'];
    note.text = notesData['note'];
    print('...' + notesData['pin'].toString());
    checkPin = notesData['pin'];
    checkArchived = notesData['archived'];

    // if (notesData['pin'] == true) {
    //   setState(() {
    //     checkPin = true;
    //   });
    // } else {
    //   setState(() {
    //     checkPin = false;
    //   });
    // }
    print("update.......$notesData");

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white10,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(22),
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 1, right: 5, bottom: 12),
              height: 52,
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            updateNotes();
                          },
                          icon: Icon(Icons.arrow_back))
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: checkPin
                                ? Icon(Icons.push_pin_rounded)
                                : Icon(Icons.push_pin_outlined),
                            onPressed: () {
                              setState(() {
                                notesData['pin'] = !checkPin;

                                print('on icon $checkPin');
                              });
                              print(checkPin);
                            }),
                        IconButton(
                          icon: Icon(Icons.add_alert_outlined),
                          onPressed: () {},
                        ),
                        IconButton(
                            icon: Icon(Icons.archive_outlined),
                            onPressed: () {
                              setState(() {
                                checkArchived = !checkArchived;
                              });
                              var snackBar = SnackBar(
                                content: checkArchived
                                    ? Text("Notes Archived")
                                    : Text('Notes Unarchived'),
                                //backgroundColor: Colors.yellow[700],
                                duration:
                                    Duration(seconds: 1, milliseconds: 250),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              updateNotes();
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  TextFormField(
                    controller: title,
                    style: TextStyle(fontSize: 25),
                    decoration: InputDecoration.collapsed(hintText: 'Title'),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: note,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration.collapsed(hintText: 'Note'),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    // decoration: InputDecoration(
                    //     hintText: 'Note',
                    //     border: InputBorder.none,
                    //     contentPadding: EdgeInsets.all(0)),
                  )
                ],
              )),
        ),
        bottomNavigationBar: BottomAppBar(
            //shape: CircularNotchedRectangle(),
            elevation: 0,
            color: Colors.white10,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              // width: 80,
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.add_box_outlined,
                              size: 25,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(
                              Icons.color_lens_outlined,
                              size: 25,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            onPressed: () {
                              //   showModalBottomSheet(
                              //       backgroundColor: _color,
                              //       context: context,
                              //       builder: (context) {
                              //         return Container(
                              //           height: 120,
                              //           child: SizedBox(
                              //             width: 50,
                              //             height: 50,
                              //             child:(
                              //               onSelectedColor: (value) {
                              //                 print(value);
                              //                 setState(() {
                              //                   _color = value;
                              //                 });
                              //               },
                              //               availableColors: [
                              //                 Colors.white,
                              //                 Colors.blueAccent,
                              //                 Colors.redAccent,
                              //                 Colors.yellowAccent,
                              //                 Colors.pinkAccent,
                              //                 Colors.purpleAccent,
                              //                 Colors.orangeAccent,
                              //                 Colors.indigoAccent,
                              //                 Colors.cyan,
                              //                 Colors.brown,
                              //                 Colors.blueGrey,
                              //                 Colors.green,
                              //               ],
                              //               initialColor: Colors.white,
                              //             ),
                              //           ),
                              //         );
                              //       });
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Edited $currentTime')],
                    ),
                  ),
                  Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 200,
                                      color: Colors.white,
                                      child: Center(
                                        child: Column(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            InkWell(
                                              child: Container(
                                                // decoration: new BoxDecoration(
                                                //   borderRadius:
                                                //       new BorderRadius.circular(
                                                //           16.0),
                                                //   color: Colors.green,
                                                // ),
                                                // decoration: Decoration(),
                                                child: Row(children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        print('icon delete');
                                                        updateNotes(true);

                                                        Navigator.pushNamed(
                                                            context, '/home');
                                                        var snackBar = SnackBar(
                                                          content: Text(
                                                              'Note move to trash'),
                                                          duration: Duration(
                                                            seconds: 1,
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                snackBar);
                                                      },
                                                      icon: Icon(
                                                          Icons.delete_sharp)),
                                                  SizedBox(
                                                    width: 25,
                                                  ),
                                                  Text('Delete'),
                                                ]),
                                              ),
                                              onTap: () {
                                                print('Delete');
                                                updateNotes(true);
                                                Navigator.pushNamed(
                                                    context, '/home');
                                                var snackBar = SnackBar(
                                                  content: Text(
                                                      'Note move to trash'),
                                                  duration: Duration(
                                                    seconds: 1,
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              },
                                            ),
                                            InkWell(
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(Icons
                                                            .content_copy)),
                                                    SizedBox(
                                                      width: 25,
                                                    ),
                                                    Text('Make a copy'),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                print('copy');
                                                Navigator.pop(context);
                                              },
                                            ),
                                            InkWell(
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon:
                                                            Icon(Icons.share)),
                                                    SizedBox(
                                                      width: 25,
                                                    ),
                                                    Text('Share'),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                print('share');
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.more_vert))
                        ]),
                  )
                ],
              ),
            )));
  }

  void updateNotes([bool trash = false]) {
    if (title.text != "" && note.text != "") {
      Map<String, dynamic> noteData = {
        "email": notesData['email'],
        "firstName": notesData['firstName'],
        "color": '',
        "note": note.text,
        "title": title.text,
        "trash": trash,
        "pin": checkPin,
        "archived": checkArchived
      };
      FirebaseFirestore.instance
          .collection("notes")
          .doc(notesData['id'])
          .update(noteData);
      if (notesData['rootSource'] == false) {
        Navigator.pushNamed(context, '/home');
      } else {
        Navigator.pushNamed(context, '/archived');
      }
    }
  }
}
