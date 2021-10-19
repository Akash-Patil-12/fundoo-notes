import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fundoo_notes_app/screens/add_notes.dart';
import 'package:fundoo_notes_app/screens/archived.dart';
import 'package:fundoo_notes_app/screens/change_password.dart';
import 'package:fundoo_notes_app/screens/forget_password.dart';
import 'package:fundoo_notes_app/screens/home.dart';
import 'package:fundoo_notes_app/screens/login.dart';
import 'package:fundoo_notes_app/screens/new_user.dart';
import 'package:fundoo_notes_app/screens/search_notes.dart';
import 'package:fundoo_notes_app/screens/trash.dart';
import 'package:fundoo_notes_app/screens/update_notes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fundoo Notes',
          initialRoute: '/signUp',
          routes: {
            '/signUp': (context) => New_User(),
            '/login': (context) => Login(),
            '/forgetPassword': (context) => Forget_Password(),
            '/changePassword': (context) => Change_Password(),
            '/home': (context) => Home(),
            '/addNotes': (context) => AddNotes(),
            '/updateNotes': (context) => UpdateNotes(),
            '/trash': (context) => Trash(),
            '/archived': (context) => Archived(),
            '/searchNotes': (context) => SearchNotes()
          },
        ));
  }
}
