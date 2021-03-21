import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_flutter/screens/error.dart';
import 'package:to_do_flutter/screens/home.dart';
import 'package:to_do_flutter/screens/loading.dart';
import 'package:to_do_flutter/screens/login.dart';
import 'package:to_do_flutter/services/auth.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: FutureBuilder(
          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return const Error();
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return Root();
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return const Loading();
          }),
    );
  }
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth(auth: _auth).user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.uid == null) {
              return Login(
                auth: _auth,
                firestore: _firestore,
              );
            } else {
              return Home(
                auth: _auth,
                firestore: _firestore,
              );
            }
          } else {
            return const Loading();
          }
        });
  }
}
