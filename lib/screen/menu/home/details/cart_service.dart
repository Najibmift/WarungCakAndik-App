import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addToCart(
      String userId, Map<String, dynamic> product, int quantity) async {
    // Check if the product already exists in the cart
    QuerySnapshot existingProducts = await usersCollection
        .doc(userId)
        .collection('cart')
        .where('productId', isEqualTo: product['productId'])
        .get();

    if (existingProducts.docs.isNotEmpty) {
      // If the product exists, update the quantity
      DocumentSnapshot existingProduct = existingProducts.docs.first;
      int existingQuantity = existingProduct['quantity'] ?? 0;

      await existingProduct.reference.update({
        'quantity': existingQuantity + quantity,
      });
    } else {
      // If the product doesn't exist, add it to the cart
      await usersCollection.doc(userId).collection('cart').add({
        ...product,
        'quantity': quantity,
      });
    }
  }
}
