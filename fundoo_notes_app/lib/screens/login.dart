import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedIn = false;
  late GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isPasswordValid = true, isEmailValid = true;
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  RegExp passwordRegExp = new RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  RegExp emailRegExp = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  List userData = [];
  Future<void> getUserData() async {
    QuerySnapshot querySnapshot = await collectionReference.get();

    final userAllData = querySnapshot.docs.map((data) => data.data()).toList();
    print(userAllData);

    querySnapshot.docs.forEach((userAllData) {
      var map = {
        'email': userAllData['email'],
        'firstName': userAllData['firstName'],
        'password': userAllData['password'],
        // 'profilImagePath': userAllData['profileImage'],
        'id': userAllData.id
      };
      userData.add(map);
    });
    print(userData);
  }

  Future<void> setSharedData(
      String email, String firstName, String profileImageId) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('email', email);
    prefs.setString('firstName', firstName);
    prefs.setBool('isLogin', true);
    prefs.setString('profileImageId', profileImageId);
    // prefs.setString('profileImagePath', profileImagePath);
    print('pppppppppppppppppppppppppppppp');
    // print(profileImagePath);
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Login'),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.yellow[700],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
              //width: MediaQuery.of(context).size.width * 0.9,
              //height: MediaQuery.of(context).size.height,
              child: Padding(
            padding: const EdgeInsets.all(20),
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
                      labelText: 'Email id',
                      labelStyle: TextStyle(color: Colors.black),
                      errorText: isEmailValid ? null : "Invalid Email",
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
                // Padding(
                //   padding: EdgeInsets.all(20),
                // ),
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
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        errorText: isPasswordValid ? null : "Invalid Password",
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
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    new GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgetPassword');
                      },
                      child: new Text('Forgot Password ?'),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    bool checkUserPresent = false;
                    if (email.text != "" && password.text != "") {
                      for (int i = 0; i < userData.length; i++) {
                        if (userData[i]['email'] == '${email.text}' &&
                            userData[i]['password'] == '${password.text}') {
                          setSharedData(
                              userData[i]['email'].toString(),
                              userData[i]['firstName'].toString(),
                              userData[i]['id'].toString());
                          //  userData[i]['profileImagePath'].toString());
                          checkUserPresent = true;
                          break;
                        }
                      }
                      if (checkUserPresent == true) {
                        print('Login ....................');
                        Navigator.pushNamed(context, '/home');
                      } else {
                        print('no...........');
                      }
                      var snackBar = SnackBar(
                        content: checkUserPresent
                            ? Text("login Successful")
                            : Text("Email and Password does not match"),
                        duration: Duration(seconds: 1, milliseconds: 250),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      var snackBar = SnackBar(
                        content: Text("Enter value in all fields"),
                        duration: Duration(seconds: 1, milliseconds: 250),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 21),
                      primary: Colors.yellow[700],
                      minimumSize: Size(double.infinity, 60)),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    _googleSignIn.signIn().then((userData) {
                      setState(() {
                        isLoggedIn = true;
                        _userObj = userData!;
                        if (_userObj.email != '') {
                          Map<String, dynamic> data = {
                            "firstName": _userObj.displayName,
                            "lastName": '',
                            "email": _userObj.email,
                            "password": '',
                            "profileImage": ""
                          };
                          FirebaseFirestore.instance
                              .collection("users")
                              .add(data);

                          setSharedData(_userObj.email,
                              _userObj.displayName.toString(), "");
                          Navigator.pushNamed(context, '/home');
                        }
                      });
                    }).catchError((e) {
                      print(e);
                    });
                  },
                  child: Text('Login With Google'),
                  style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 21),
                      primary: Colors.yellow[700],
                      minimumSize: Size(double.infinity, 60)),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have and account?'),
                    TextButton(
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                          primary: Colors.yellow[700]),
                      onPressed: () {
                        Navigator.pushNamed(context, '/signUp');
                      },
                      child: const Text('Sign Up'),
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
