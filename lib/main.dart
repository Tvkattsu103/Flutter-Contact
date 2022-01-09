import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:contact_database/screen/contact.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // ignore: prefer_const_constructors
    options: FirebaseOptions(
      apiKey: "AIzaSyDv8O1AIZdx9yrYrEHnGTGWbg1zSN8YRJg",
      databaseURL: "https://fluttercontacts-fe31a-default-rtdb.firebaseio.com/",
      appId: "1:1063859161901:android:40753546d400fc38ae61a4",
      messagingSenderId: "1063859161901",
      projectId: "fluttercontacts-fe31a",
    ), //fix loi khong tim thay Firebase
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Database',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.redAccent,
      ),
      home: Contacts(),
    );
  }
}
