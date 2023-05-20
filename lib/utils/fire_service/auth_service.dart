// auth_service.dart
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users');

  // Singleton stuff
  static final AuthService _instance = AuthService._();
  AuthService._();
  static AuthService instance() => _instance;

  // Method used for signing up with email, password, and a username
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password, String userName) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create a new user document in Firestore using the user's uid as the document ID
      await _usersCollection.doc(userCredential.user!.uid).set({
        'email': email,
        'userType': 'student',
        // Add any additional fields we may want to store for the user
        'userName': userName,
        'score': 0,
        'photoUrl': '',
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getUserType() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw FirebaseAuthException(message: 'No user signed in', code: '');
    }
    final userDoc = await _usersCollection.doc(currentUser.uid).get();
    final userType =
    (userDoc.data() as Map<String, dynamic>)?['userType'] as String?;
    return userType.toString();
  }

  Future<String> getCurrentUserName() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw FirebaseAuthException(message: 'No user signed in', code: '');
    }
    final userDoc = await _usersCollection.doc(currentUser.uid).get();
    final userName =
    (userDoc.data() as Map<String, dynamic>)?['userName'] as String?;
    print(userName);
    return userName.toString();
  }

  // Method used for signing out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Return current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> updateProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        // Upload the file to Firebase
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child(user.uid);
          await ref.putFile(imageFile);

          // Update the user profile
          final photoUrl = await ref.getDownloadURL();
          await user.updatePhotoURL(photoUrl);
          await _usersCollection.doc(user.uid).update({'photoUrl': photoUrl});

          // Refresh the current user's data
          await user.reload();
        }
      } catch (e) {
        print('Error updating profile picture: $e');
      }
    }
  }

  String? getCurrentUserId() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }
}
