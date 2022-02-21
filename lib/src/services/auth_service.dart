import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String? theError;

  //a void func to set the error message
  void setTheError(String? err) {
    theError = err;
    notifyListeners();
  }

  User? theUser = FirebaseAuth
      .instance.currentUser; //to have the current user as the initial value

  void setTheUser(User? user) {
    theUser = user;
    notifyListeners();
  }

  //method to register using email and password
  Future<UserCredential?> registerUsingEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential theUserCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      setTheUser(theUserCredentials.user);
      setTheError(null);
      return theUserCredentials;
    } on FirebaseAuthException catch (e) {
      setTheError(e.message);
    }
  }

  //method to login with email and password
  Future<UserCredential?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential theUserCredentials = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      setTheUser(theUserCredentials.user);
      setTheError(null);
      return theUserCredentials;
    } on FirebaseAuthException catch (err) {
      setTheError(err.message!);
      debugPrint("==========>>>>>>" + err.message!);
    }
  }

  // logout method
  logOut() async {
    await _firebaseAuth.signOut();
    setTheUser(null);
  }
}
