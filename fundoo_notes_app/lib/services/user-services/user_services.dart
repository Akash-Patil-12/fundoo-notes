import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserServices {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  List userData = [];
  String id = "";
  // bool checkUserPresent = false;

// get userData list and email check it available in firebase return true else false
  String checkUserEmailPresent(List userData, TextEditingController email) {
    print(userData);
    for (int i = 0; i < userData.length; i++) {
      print(userData[i]['email']);
      if (userData[i]['email'] == '${email.text}') {
        print('......');
        id = userData[i]['id'];
        print(id);
        //   return id;
      }
    }
    //id = null;
    return id;
  }

//

}
