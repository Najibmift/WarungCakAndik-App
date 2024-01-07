import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? getCurrentUserUid() {
    return _auth.currentUser?.uid;
  }

  Future<void> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user information in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      // Handle other FirebaseAuthException errors as needed
      throw e;
    } catch (e) {
      print('Error creating user: $e');
      throw e;
    }
  }

  Future<void> signInWithEmailAndPassword(
      String emailOrUsername, String password) async {
    try {
      bool isEmail = emailOrUsername.contains('@');

      UserCredential userCredential;
      if (isEmail) {
        // Sign in with email
        userCredential = await _auth.signInWithEmailAndPassword(
          email: emailOrUsername,
          password: password,
        );
      } else {
        // Sign in with username
        String? email = await getEmailFromUsername(emailOrUsername);

        if (email != null) {
          userCredential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          throw FirebaseAuthException(
            code: 'username-not-found',
            message: 'The provided username was not found.',
          );
        }
      }

      print('User signed in: ${userCredential.user!.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'username-not-found') {
        print('No user found for that email or username.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      // Handle other FirebaseAuthException errors as needed
      throw e;
    } catch (e) {
      print('Error signing in: $e');
      throw e;
    }
  }

  Future<String?> getEmailFromUsername(String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.get('email') as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting email from username: $e');
      throw e;
    }
  }

  Future<String?> getUsernameFromUid(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(uid).get();

      if (documentSnapshot.exists) {
        return documentSnapshot.get('username') as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting username from UID: $e');
      throw e;
    }
  }

  Future<String?> getUsername() async {
    try {
      String? uid = getCurrentUserUid();
      if (uid != null) {
        return await getUsernameFromUid(uid);
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      print('Error getting username: $e');
      throw e;
    }
  }

  // Sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
