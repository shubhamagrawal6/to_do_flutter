import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_flutter/models/todo.dart';

class Database {
  final FirebaseFirestore firestore;

  Database({this.firestore});

  Stream<List<TodoModel>> streamTodos({String uid}) {
    try {
      return firestore
          .collection("user")
          .doc(uid)
          .collection("todos")
          .where("done", isEqualTo: false)
          .snapshots()
          .map((query) {
        final List<TodoModel> retVal = <TodoModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(TodoModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<TodoModel>> streamCompleteTodos({String uid}) {
    try {
      return firestore
          .collection("user")
          .doc(uid)
          .collection("todos")
          .where("done", isEqualTo: true)
          .snapshots()
          .map((query) {
        final List<TodoModel> retVal = <TodoModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(TodoModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodo({String uid, String content}) async {
    try {
      firestore.collection("user").doc(uid).collection("todos").add({
        "content": content,
        "done": false,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTodo({String uid, String todoId, bool newValue}) async {
    try {
      firestore
          .collection("user")
          .doc(uid)
          .collection("todos")
          .doc(todoId)
          .update({
        "done": newValue,
      });
    } catch (e) {
      rethrow;
    }
  }
}
