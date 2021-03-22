import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_flutter/models/todo.dart';
import 'package:to_do_flutter/screens/loading.dart';
import 'package:to_do_flutter/services/auth.dart';
import 'package:to_do_flutter/services/database.dart';
import 'package:to_do_flutter/widgets/todo_card.dart';

class Home extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Home({Key key, this.auth, this.firestore}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String email = widget.auth.currentUser.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        actions: [
          IconButton(
            key: const ValueKey("signOut"),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              HapticFeedback.lightImpact();
              Auth(auth: widget.auth).signOut();
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
              ),
              currentAccountPicture: Image.asset("assets/images/Profile.png"),
              accountName: Text(email),
              accountEmail: null,
            ),
            ListTile(
              leading: IconButton(
                icon: const Icon(Icons.person_remove),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Auth(auth: widget.auth).removeAccount();
                },
              ),
              title: const Text("Remove your account"),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Add To-Do Here:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const ValueKey("addField"),
                      controller: _todoController,
                    ),
                  ),
                  IconButton(
                    key: const ValueKey("addButton"),
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      if (_todoController.text != "") {
                        setState(() {
                          Database(firestore: widget.firestore).addTodo(
                              uid: widget.auth.currentUser.uid,
                              content: _todoController.text);
                          _todoController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Your To-Do List",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: Database(firestore: widget.firestore)
                  .streamTodos(uid: widget.auth.currentUser.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TodoModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData == false) {
                    return const Center(
                      child: Text("You don't have any unfinished To-Dos"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        return TodoCard(
                          firestore: widget.firestore,
                          uid: widget.auth.currentUser.uid,
                          todo: snapshot.data[index],
                        );
                      },
                    );
                  }
                } else {
                  return const Loading();
                }
              },
            ),
          ),
          const Text(
            "Your Completed To-Dos",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: Database(firestore: widget.firestore)
                  .streamCompleteTodos(uid: widget.auth.currentUser.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TodoModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData == false) {
                    return const Center(
                      child: Text("You don't have any completed To-Dos"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        return TodoCard(
                          firestore: widget.firestore,
                          uid: widget.auth.currentUser.uid,
                          todo: snapshot.data[index],
                        );
                      },
                    );
                  }
                } else {
                  return const Loading();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
