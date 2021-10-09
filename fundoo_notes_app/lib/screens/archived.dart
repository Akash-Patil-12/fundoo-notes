import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundoo_notes_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Archived extends StatefulWidget {
  Archived({Key? key}) : super(key: key);

  @override
  _ArchivedState createState() => _ArchivedState();
}

class _ArchivedState extends State<Archived> {
  bool checkListOrGride = false;
  String sharedPreferenceEmail = "";
  List<dynamic> allNotesData = [];
  Future<void> getNotesData() async {
    final prefs = await SharedPreferences.getInstance();
    sharedPreferenceEmail = prefs.getString('email')!;
    Query<Map<String, dynamic>> collectionReference = FirebaseFirestore.instance
        .collection('notes')
        .where("archived", isEqualTo: true)
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
        'pin': notesAllData['pin'],
        'archived': notesAllData['archived'],
        'id': notesAllData.id
      };
      setState(() {
        allNotesData.add(map);
      });
    });
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
        backgroundColor: Colors.white10,
        foregroundColor: Colors.black,
        title: Text('Archive'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined)),
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
        ],
      ),
      body: checkListOrGride
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: allNotesData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 2, crossAxisSpacing: 2),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(),
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
                              'rootSource': true
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
              itemCount: allNotesData.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      //   print(allNotesData[index]);
                      Navigator.pushNamed(context, '/updateNotes', arguments: {
                        'email': allNotesData[index]['email'],
                        'firstName': allNotesData[index]['firstName'],
                        'color': allNotesData[index]['color'],
                        'note': allNotesData[index]['note'],
                        'title': allNotesData[index]['title'],
                        'pin': allNotesData[index]['pin'],
                        'archived': allNotesData[index]['archived'],
                        'id': allNotesData[index]['id']
                      });
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
