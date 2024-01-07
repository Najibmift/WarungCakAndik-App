import 'package:cloud_firestore/cloud_firestore.dart';

class GetProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUsername(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(uid).get();

      if (documentSnapshot.exists) {
        return documentSnapshot.get('username') as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting username: $e');
      throw e;
    }
  }
}
