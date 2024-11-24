import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final String collectionName = 'authentication';



Future<User?> createUserWithEmailAndPassword(
      String email, String password, String fullName, String userType) async {
    try {
      // Create user with Firebase Authentication
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If user creation is successful, save user inx`fo to Firestore
      if (cred.user != null) {
        await _firestore.collection('authentication').doc(cred.user!.uid).set({

          'auth_id': cred.user!.uid,
          'email': email,
          'name': fullName,
          'password': password, // Storing the password as is
          'role': 'user',
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('uid', cred.user!.uid);
      }

      return cred.user;
    } catch (e) {
      log("Error creating user: $e");
    }
    return null;
  }

  Future<Map<String, String>?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      // Fetch the document from Firestore by email
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve user data
        final userData = querySnapshot.docs.first.data();

        // Check if the entered password matches the stored password
        if (userData['password'] == password) {
          if (userData['role'] == null) {
            await querySnapshot.docs.first.reference
                .update({'role': 'user'});
          }
          // Return email and auth_id on success
          return {'email': userData['email'], 'auth_id': userData['auth_id']};
        } else {
          // Return null if password is incorrect
          return null;
        }
      } else {
        // Return null if no user found with this email
        return null;
      }
    } catch (error) {
      log("Error during login: $error");
      return null; // Return null in case of error
    }
  }
}
