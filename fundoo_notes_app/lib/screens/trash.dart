import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundoo_notes_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trash extends StatefulWidget {
  Trash({Key? key}) : super(key: key);

  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  bool checkNotesList = true;
  List<dynamic> allNotesData = [];
  String? sharedPreferenceEmail;

// Fetch data from firebase
  Future<void> getNotesData() async {
    final prefs = await SharedPreferences.getInstance();
    sharedPreferenceEmail = prefs.getString('email')!;
    Query<Map<String, dynamic>> collectionReference = FirebaseFirestore.instance
        .collection('notes')
        .where("trash", isEqualTo: true)
        .where("email", isEqualTo: sharedPreferenceEmail);
    QuerySnapshot querySnapshot = await collectionReference.get();

    final notesAllData = querySnapshot.docs.map((data) => data.data()).toList();
    print(notesAllData);
    querySnapshot.docs.forEach((notesAllData) {
      var map = {
        'email': notesAllData['email'],
        'firstName': notesAllData['firstName'],
        'color': notesAllData['color'],
        'note': notesAllData['note'],
        'title': notesAllData['title'],
        'id': notesAllData.id
      };
      setState(() {
        allNotesData.add(map);
      });
    });
    // print(allNotesData);
    // if (allNotesData.length != 0) {
    //   checkNotesList = false;
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),
      appBar: AppBar(
        elevation: 0,
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white10,
        foregroundColor: Colors.black,
        title: Text('Trash'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: allNotesData.length == 0
          ? Center(child: Text('No Notes in Trash'))
          : ListView.builder(
              itemCount: allNotesData.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      //   print(allNotesData[index]);
                      // Navigator.pushNamed(context, '/updateNotes',
                      //     arguments: {
                      //       'email': allNotesData[index]['email'],
                      //       'firstName': allNotesData[index]['firstName'],
                      //       'color': allNotesData[index]['color'],
                      //       'note': allNotesData[index]['note'],
                      //       'title': allNotesData[index]['title'],
                      //       'id': allNotesData[index]['id']
                      //     });
                    },
                    child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black12, width: 1),
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
    );
  }
}
