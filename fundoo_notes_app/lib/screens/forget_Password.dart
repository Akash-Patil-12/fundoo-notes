import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundoo_notes_app/services/user-services/user_services.dart';

class Forget_Password extends StatefulWidget {
  Forget_Password({Key? key}) : super(key: key);

  @override
  _Forget_PasswordState createState() => _Forget_PasswordState();
}

class _Forget_PasswordState extends State<Forget_Password> {
  UserServices userServices = new UserServices();
  bool isPasswordValid = true, isEmailValid = true;

  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  RegExp passwordRegExp = new RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  RegExp emailRegExp = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  List userData = [];
  // var id;
  String id = "";
  Future<void> getUserData() async {
    QuerySnapshot querySnapshot = await collectionReference.get();

    final userAllData = querySnapshot.docs.map((data) => data.data()).toList();
    print(userAllData);

    querySnapshot.docs.forEach((userAllData) {
      var map = {
        'email': userAllData['email'],
        'password': userAllData['password'],
        'id': userAllData.id
      };
      userData.add(map);
    });
    print(userData);
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    // id = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Change Password')),
        backgroundColor: Colors.yellow[700],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/note_images.jpeg',
                    height: 150,
                    fit: BoxFit.fill,
                    color: const Color.fromRGBO(255, 255, 255, 0.4),
                    colorBlendMode: BlendMode.modulate),
                SizedBox(
                  height: 35,
                ),
                SizedBox(
                  height: 80,
                  child: TextField(
                    controller: email,
                    onChanged: (value) {
                      if (emailRegExp.hasMatch(value)) {
                        isEmailValid = true;
                      } else {
                        isEmailValid = false;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      errorText: isEmailValid ? null : "Invalid Email",
                      labelText: 'Email id',
                      labelStyle: TextStyle(color: Colors.black),
                      border: new OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                              color: isEmailValid ? Colors.yellow : Colors.red,
                              width: 2)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    bool checkUserPresent = false;

                    if (email.text != '') {
                      id = userServices.checkUserEmailPresent(userData, email);
                      // for (int i = 0; i < userData.length; i++) {
                      //   if (userData[i]['email'] == '${email.text}') {
                      //     id = userData[i]['id'];
                      //     print(id);
                      //     checkUserPresent = true;
                      //     break;
                      //   }
                      // }
                      if (id != "") {
                        checkUserPresent = true;
                      }
                    }

                    var snackBar = SnackBar(
                      content: checkUserPresent
                          ? Text("Email match")
                          : Text("Email not match"),
                      duration: Duration(seconds: 1, milliseconds: 250),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    if (checkUserPresent == true && email.text != '') {
                      Navigator.pushNamed(context, '/changePassword',
                          arguments: {'id': id});
                    }
                  },
                  child: Text('Conform Email'),
                  style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 21),
                      primary: Colors.yellow[700],
                      minimumSize: Size(double.infinity, 60)),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
