import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              return const Scaffold(
                  backgroundColor: Colors.greenAccent,
                  body: Center(child: Text("Error in the app")));
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return Root();
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return const Scaffold(
                backgroundColor: Colors.greenAccent,
                body: Center(child: Text("Loading...")));
          }),
    );
  }
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "App started",
        style: TextStyle(
          color: Colors.amber,
        ),
      ),
    );
  }
}
