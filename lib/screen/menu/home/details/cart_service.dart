import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addToCart(String userId, Map<String, dynamic> product) async {
    await usersCollection.doc(userId).collection('cart').add(product);
  }
}
