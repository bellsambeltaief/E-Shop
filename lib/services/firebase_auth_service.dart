import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Le service d'authentification avec le Firebase
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user account
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      if (user != null) {
        // Add user data to Firestore
        await _addUserData(
          user.uid,
          email,
          firstName,
          lastName,
        );
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Firebase Auth Error during sign-up: ${e.message}");
      }
      return null;
    }
  }

  // Generic sign-in method for users
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Firebase Auth Error during sign-in: ${e.message}");
      }
      return null;
    }
  }

  /// Add the user data
  Future<void> _addUserData(
    String userId,
    String email,
    String firstName,
    String lastName,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error adding user data to Firestore: $e");
      }
    }
  }

  // Method to log out the user
  Future<void> logOut() async {
    try {
      await _auth.signOut();
      if (kDebugMode) {
        print("User has been logged out successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error logging out: $e");
      }
      throw FirebaseAuthException(code: 'LOGOUT_FAILED', message: 'Failed to log out.');
    }
  }

  String getCurrentUserId() {
    // Récupérez l'ID de l'utilisateur connecté à partir de FirebaseAuth
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Si aucun utilisateur n'est connecté, vous pouvez renvoyer null ou lever une erreur selon vos besoins
      throw Exception("No user currently signed in.");
    }
  }

  /// Method to fetch full user profile from Firestore
  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving user profile: $e");
      }
      return null;
    }
  }
}
