// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<UserCredential> signUpWithEmailAndPassword(String email,
      String password, String userName) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a new user document in Firestore using the user's uid as the document ID
      await _usersCollection.doc(userCredential.user!.uid).set({
        'email': email,
        'userType': 'student',
        // add any additional fields we may want to store for the user
        'userName': userName,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
 Future<bool> isUserStudent() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw FirebaseAuthException(message: 'No user signed in', code: '');
    }
    final userDoc = await _usersCollection.doc(currentUser.uid).get();
    final userType = (userDoc.data() as Map<String, dynamic>)?['userType'] as String?;
    if (userType == 'student') {
      return true;
    } else {
      return false;
    }
  }
  }
