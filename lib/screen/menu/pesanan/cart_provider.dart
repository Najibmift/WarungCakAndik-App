import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  bool _isLoading = false; // Add a loading indicator variable
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> _cartItems = [];
  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Map<String, dynamic> item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void _removeItemFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index]['quantity'] = newQuantity;
      notifyListeners();
    }
  }

  // Method to fetch cart data from Firestore
  Future<void> fetchCartData(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> cartSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('cart')
              .get();

      _cartItems =
          cartSnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return doc.data()!;
      }).toList();
      notifyListeners();
    } catch (error) {
      // Handle error as needed
      print('Error fetching cart data: $error');
    }
  }

  Future<void> removeItemFromFirestore(String userId, int index) async {
    var doc_ref = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .get();

    List<String> documentIds = [];

    doc_ref.docs.forEach((result) {
      // Tambahkan documentId ke dalam array
      documentIds.add(result.id);

      // Cetak documentId (opsional)
      print(result.id);
    });
    try {
      _isLoading = true;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(documentIds[index])
          .delete();

      // Remove the item from _cartItems
      _removeItemFromCart(index);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      // Handle error as needed
      print('Error removing item from Firestore: $error');
    }
  }
}
