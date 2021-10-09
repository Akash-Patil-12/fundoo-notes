import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class New_User extends StatefulWidget {
  const New_User({Key? key}) : super(key: key);

  @override
  _New_UserState createState() => _New_UserState();
}

class _New_UserState extends State<New_User> {
  bool checkEmailPresent = false;

  bool isFirstNameValid = true,
      isLastNameValid = true,
      isPasswordValid = true,
      isEmailValid = true;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  RegExp regExp = new RegExp(r'^[A-Z][-a-zA-Z]+$');
  RegExp passwordRegExp = new RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  RegExp emailRegExp = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  Future<void> getSharedData() async {
    final prefs = await SharedPreferences.getInstance();
    checkEmailPresent = prefs.containsKey('email');
    print('......$checkEmailPresent');
    // print(firstName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('User Registration')),
        backgroundColor: Colors.yellow[700],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
              // width: MediaQuery.of(context).size.width * 0.9,
              //height: MediaQuery.of(context).size.height,
              child: Padding(
            padding: const EdgeInsets.all(15.0),
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
                  height: 15,
                ),
                SizedBox(
                  height: 80,
                  child: TextField(
                    controller: firstName,
                    onChanged: (value) {
                      if (regExp.hasMatch(value)) {
                        isFirstNameValid = true;
                      } else {
                        isFirstNameValid = false;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(color: Colors.black),
                      errorText: isFirstNameValid ? null : "Invalid First Name",
                      border: new OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                              color:
                                  isFirstNameValid ? Colors.yellow : Colors.red,
                              width: 2)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 80,
                  child: TextField(
                    controller: lastName,
                    onChanged: (value) {
                      if (regExp.hasMatch(value)) {
                        isLastNameValid = true;
                      } else {
                        isLastNameValid = false;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      errorText: isLastNameValid ? null : "Invalid Last Name",
                      labelText: 'Last Name',
                      labelStyle: TextStyle(color: Colors.black),
                      border: new OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                              color:
                                  isLastNameValid ? Colors.yellow : Colors.red,
                              width: 2)),
                    ),
                  ),
                ),
                SizedBox(height: 15),
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
                SizedBox(
                  height: 80,
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    onChanged: (value) {
                      if (passwordRegExp.hasMatch(value)) {
                        isPasswordValid = true;
                      } else {
                        isPasswordValid = false;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        errorText: isPasswordValid ? null : "Invalid Password",
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                                color: isPasswordValid
                                    ? Colors.yellow
                                    : Colors.red,
                                width: 2))),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (firstName.text != "" &&
                        lastName.text != "" &&
                        email.text != "" &&
                        password.text != "") {
                      Map<String, dynamic> data = {
                        "firstName": firstName.text,
                        "lastName": lastName.text,
                        "email": email.text,
                        "password": password.text
                      };
                      var snackBar = SnackBar(
                        content: Text("Register Successful"),
                        //backgroundColor: Colors.yellow[700],
                        duration: Duration(seconds: 1, milliseconds: 250),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      FirebaseFirestore.instance.collection("users").add(data);
                      Navigator.pushNamed(context, '/login');
                    } else {
                      var snackBar = SnackBar(
                        content: Text("Enter value in all fields"),
                        //backgroundColor: Colors.yellow[700],
                        duration: Duration(seconds: 1, milliseconds: 250),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text('Register'),
                  style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 21),
                      primary: Colors.yellow[700],
                      minimumSize: Size(double.infinity, 60)),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Have an account with us?'),
                    TextButton(
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                          primary: Colors.yellow[700]),
                      onPressed: () {
                        if (checkEmailPresent == true) {
                          Navigator.pushNamed(context, '/home');
                        } else {
                          Navigator.pushNamed(context, '/login');
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ],
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
