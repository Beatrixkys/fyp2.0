import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/services/models/user.dart';

class AuthService {
  //create instance of the firebase auth object
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signInWithEmailAndPassword(
      String sEmail, String sPassword, BuildContext context) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: sEmail, password: sPassword);
      User? user = result.user;

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      e.toString();
    }
  }

  Future register(
      String email, String password, String name, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      user = result.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;

      //add user to database

      if (user == null) {
        throw Exception("No user found");
      } else {
        //create new user document to the database
        //await DatabaseService(user.uid).saveUser(name, email);
      }
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      String message = e.toString();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(message),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  //signout

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
