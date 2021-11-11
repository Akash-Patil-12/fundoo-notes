import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

var lastDocument;
bool moreProductsAvailable = true;
List allLable = [];

class Notes {
  late String email;
  late String firstName;
  late String color;
  late String note;
  late String title;
  late bool pin;
  late bool archived;
  late String id;

  Notes(this.email, this.firstName, this.color, this.note, this.title, this.pin,
      this.archived, this.id);

  Notes.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['firstName'];
    color = json['color'];
    note = json['note'];
    title = json['title'];
    pin = json['pin'];
    archived = json['archived'];
    id = json['id'];
  }
}

Future<void> getNotesData() async {
  final prefs = await SharedPreferences.getInstance();
  var sharedPreferenceEmail = prefs.getString('email')!;
  //var url = prefs.getString('profileImagePath')!;
  // print(url);
  // setState(() {
  //   profileImagePath = url;
  //   print(profileImagePath);
  // });

  Query collectionReference = FirebaseFirestore.instance
      .collection('notes')
      .orderBy("title", descending: true)
      .limit(10)
      .where("trash", isEqualTo: false)
      .where("archived", isEqualTo: false)
      .where("email", isEqualTo: sharedPreferenceEmail);
  //.limit(8);
  //.orderBy("title", descending: true);
  //.orderBy("title");
  // setState(() {
  //   loadingProducts = true; /////////
  // });
  // loadingProducts = true; /////////
  QuerySnapshot querySnapshot = await collectionReference.get();
  // _notes = querySnapshot.docs;
  print('........');
  if (querySnapshot.docs.length > 0) {
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
  }
  print(lastDocument);
  if (querySnapshot.docs.length < 10) {
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
    // setState(() {
    //   allNotesData.add(map);
    //   // allNotesData.sort();
    //   // allNotesData = allNotesData.reversed.toList();
    // });
    print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
    // print(allNotesData);
  });
  // print(allNotesData);
  // setState(() {
  //   // allNotesData.map.keys.toList()..sort();
  //   // allNotesData.sort((a, b) => a.compareTo(b));
  //   loadingProducts = false;
  // });
}

  getLables() async {
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
  return allLable;
}
