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

  void updateLocalQuantity(int index, int newQuantity) {
    _cartItems[index]['quantity'] = newQuantity;
    notifyListeners();
  }

  Future<void> updateQuantity(String userId, int index, int newQuantity) async {
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
      // print(result.id);
    });
    try {
      // Update quantity in the local state
      notifyListeners();

      if (documentIds[index] != null) {
        // Update quantity in the Firestore database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(documentIds[index])
            .update({'quantity': newQuantity});
      } else {
        print('Error updating quantity: ProductId is null.');
      }
    } catch (error) {
      // Handle error as needed
      print('Error updating quantity: $error');
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
      print(_cartItems);
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
      // print(result.id);
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

// Calculate total price of items in the cart
  double calculateTotalPrice() {
    double totalPrice = 0.0;

    for (var item in _cartItems) {
      double itemPrice = double.parse(item['price'].toString());
      int itemQuantity = item['quantity'] ??
          1; // Assuming a default quantity of 1 if not present
      double itemTotal = itemPrice * itemQuantity;
      totalPrice += itemTotal;
    }

    return totalPrice;
  }
}
