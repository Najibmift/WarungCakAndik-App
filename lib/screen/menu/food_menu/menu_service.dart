import 'package:cloud_firestore/cloud_firestore.dart';

class MenuFirestoreService {
  Future<List<Map<String, dynamic>>> getFoodList(String productId) async {
    CollectionReference foodCollection =
        FirebaseFirestore.instance.collection('product/$productId/makanan');

    QuerySnapshot querySnapshot = await foodCollection.get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getDrinkList(String productId) async {
    CollectionReference drinkCollection =
        FirebaseFirestore.instance.collection('product/$productId/minuman');

    QuerySnapshot querySnapshot = await drinkCollection.get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
