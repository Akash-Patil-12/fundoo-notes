import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Change_Password extends StatefulWidget {
  Change_Password({Key? key}) : super(key: key);

  @override
  _Change_PasswordState createState() => _Change_PasswordState();
}

class _Change_PasswordState extends State<Change_Password> {
  bool isPasswordValid = true, isConformPasswordValid = true;
  Map data = {};
  TextEditingController password = TextEditingController();
  TextEditingController conformPassword = TextEditingController();

  RegExp passwordRegExp = new RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;

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
                SizedBox(
                  height: 80,
                  child: TextField(
                    controller: conformPassword,
                    obscureText: true,
                    onChanged: (value) {
                      print('.....' + data['id']);
                      if (passwordRegExp.hasMatch(value)) {
                        isConformPasswordValid = true;
                      } else {
                        isConformPasswordValid = false;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        errorText:
                            isConformPasswordValid ? null : "Invalid Password",
                        labelText: 'Conform Password',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                                color: isConformPasswordValid
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
                    if (password.text != '' && conformPassword.text != '') {
                      if (password.text == conformPassword.text) {
                        print('conform');
                        CollectionReference userinfo =
                            FirebaseFirestore.instance.collection('users');
                        userinfo
                            .doc(data['id'])
                            .update({'password': password.text});
                        var snackBar = SnackBar(
                          content: Text('Password Updated Successfully'),
                          duration: Duration(seconds: 1, milliseconds: 250),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pushNamed(context, '/login');
                      } else {
                        print('not match');
                        var snackBar = SnackBar(
                          content: Text('Password not match'),
                          duration: Duration(seconds: 1, milliseconds: 250),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      var snackBar = SnackBar(
                        content: Text('Empty fields'),
                        duration: Duration(seconds: 1, milliseconds: 250),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text('Change Password'),
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
