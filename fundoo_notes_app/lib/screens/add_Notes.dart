import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNotes extends StatefulWidget {
  AddNotes({Key? key}) : super(key: key);
  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  List<Color> colors = [
    Colors.white,
    Colors.pink,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blueAccent,
    Colors.grey,
    Colors.purpleAccent,
    Colors.blueGrey,
  ];
  //var colorSelected = Colors.green;
  late Color _color = Colors.white;
  bool pin = false, archived = false;
  TextEditingController title = new TextEditingController();
  TextEditingController note = new TextEditingController();
  late String email, firstName;
  dynamic currentTime = DateFormat.jm().format(DateTime.now());

  Future<void> getSharedData() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email')!;
    firstName = prefs.getString('firstName')!;
    print(email);
    print(firstName);
  }

  @override
  void initState() {
    super.initState();
    getSharedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _color,
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
                            addNotes();
                          },
                          icon: Icon(Icons.arrow_back))
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: pin
                                ? Icon(Icons.push_pin_rounded)
                                : Icon(Icons.push_pin_outlined),
                            onPressed: () {
                              setState(() {
                                pin = !pin;
                              });
                            }),
                        IconButton(
                          icon: Icon(Icons.add_alert_outlined),
                          onPressed: () {},
                        ),
                        IconButton(
                            icon: Icon(Icons.archive_outlined),
                            onPressed: () {
                              archived = !archived;
                              addNotes(false, archived);
                              Navigator.pushNamed(context, '/home');
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
                  )
                ],
              )),
        ),
        bottomNavigationBar: BottomAppBar(
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
                              showModalBottomSheet(
                                  backgroundColor: _color,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 200,
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 30, top: 40),
                                            child: Text('Colors'),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: colors.length,
                                              itemBuilder: (BuildContext
                                                          context,
                                                      int index) =>
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          print(colors[index]);
                                                          String valueString =
                                                              colors[index]
                                                                  .toString()
                                                                  .split(
                                                                      '(0x')[1]
                                                                  .split(
                                                                      ')')[0];
                                                          int value = int.parse(
                                                              valueString,
                                                              radix: 16);
                                                          Color otherColor =
                                                              new Color(value);
                                                          print(otherColor);
                                                          setState(() {
                                                            _color = otherColor;
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  colors[index],
                                                              border: new Border
                                                                      .all(
                                                                  color: Colors
                                                                      .black12,
                                                                  width: 2.0)),
                                                          // child: Center(
                                                          //     child: Text('Text')),
                                                        ),
                                                      )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            InkWell(
                                              child: Container(
                                                child: Row(children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        print('icon delete');
                                                        addNotes(true);
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
                                                addNotes(true);
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
                                            InkWell(
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/createLable');
                                                        },
                                                        icon: Icon(Icons
                                                            .label_outline)),
                                                    SizedBox(
                                                      width: 25,
                                                    ),
                                                    Text('Lable'),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                print('Lable');
                                                Navigator.pushNamed(
                                                    context, '/createLable');
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

  void addNotes([bool trash = false, bool archived = false]) {
    if (title.text != "" && note.text != "") {
      Map<String, dynamic> noteData = {
        "email": email,
        "firstName": firstName,
        "color": _color.toString(),
        "note": note.text,
        "title": title.text,
        "trash": trash,
        "archived": archived,
        "pin": pin
      };
      FirebaseFirestore.instance.collection("notes").add(noteData);
    }
    Navigator.pushNamed(context, '/home');
  }
}
