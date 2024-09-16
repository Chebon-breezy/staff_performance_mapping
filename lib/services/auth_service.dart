import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get user => _auth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection('users').doc(result.user!.uid).set({
        'name': name,
        'email': email,
        'role': 'user',
      });
      notifyListeners();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getUserRole(String uid) async {
    try {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc['role'];
    } catch (e) {
      return 'user';
    }
  }


  Future<bool> signInAdmin(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        // Check if the user is an admin
        DocumentSnapshot adminDoc = await _firestore.collection('admins').doc(user.uid).get();
        if (adminDoc.exists) {
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Method to check if the current user is an admin
  Future<bool> isCurrentUserAdmin() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot adminDoc = await _firestore.collection('admins').doc(user.uid).get();
      return adminDoc.exists;
    }
    return false;
  }

  Future<bool> isAdmin() async {
  User? user = _auth.currentUser;
  if (user != null) {
    String role = await getUserRole(user.uid);
    return role == 'admin'; // Role is 'admin' if user is an admin
  }
  return false;
}
}
