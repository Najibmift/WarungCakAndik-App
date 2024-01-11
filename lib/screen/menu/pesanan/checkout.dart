import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app_flutter_1/screen/menu/pesanan/cart_provider.dart';
import 'package:provider/provider.dart';

class CheckoutPopup extends StatefulWidget {
  final double totalPrice;

  CheckoutPopup({required this.totalPrice});

  @override
  _CheckoutPopupState createState() => _CheckoutPopupState();
}

class _CheckoutPopupState extends State<CheckoutPopup> {
  String selectedOrderType = 'Dine In';
  int selectedTableNumber = 1;
  int selectedLevel = 0; // Initial level

  Stream<List<int>> getTableNumbers(int selectedLevel) {
    CollectionReference mejaCollection =
        FirebaseFirestore.instance.collection('meja');

    return mejaCollection
        .doc('1AZnugeof9l54dz6sbaB')
        .collection('meja_$selectedLevel')
        .snapshots()
        .map((snapshot) {
      List<int> tableNumbers = [];
      snapshot.docs.forEach((doc) {
        int tableNumber = int.parse(doc.id.split('_')[1]);
        tableNumbers.add(tableNumber);
      });

      print('Table Numbers for Level $selectedLevel: $tableNumbers');

      return tableNumbers;
    });
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    Stream<List<int>> tableNumbersStream = getTableNumbers(selectedLevel);

    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: Colors.white,
                child: Text(
                  'Checkout Details',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Display details of items in the cart
            Container(
              height: 250,
              child: ListView.builder(
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> cartItem = cartProvider.cartItems[index];
                  return ListTile(
                    title:
                        Text(cartItem['name'] ?? 'Product Name not available'),
                    subtitle: Text(
                        'Price: \Rp. ${cartItem['price'] ?? 'Price not available'}'),
                    trailing: Text(
                        'Quantity: ${cartItem['quantity'] ?? 'Quantity not available'}'),
                  );
                },
              ),
            ),

            SizedBox(height: 10.0),

            // Display the total price
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: Colors.white,
              child: Text(
                'Total Price: \Rp. ${widget.totalPrice}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20.0),

            // Add order type and table selection
            Column(
              children: [
                // Order type selection
                Row(
                  children: [
                    Radio(
                      value: 'Dine In',
                      groupValue: selectedOrderType,
                      onChanged: (value) {
                        setState(() {
                          selectedOrderType = value as String;
                        });
                      },
                    ),
                    Text('Dine In'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 'Take Away',
                      groupValue: selectedOrderType,
                      onChanged: (value) {
                        setState(() {
                          selectedOrderType = value as String;
                        });
                      },
                    ),
                    Text('Take Away'),
                  ],
                ),
              ],
            ),

            // Display table number selection if Dine In is selected
            if (selectedOrderType == 'Dine In')
              Center(
                child: Column(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Select Table Number:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Use StreamBuilder to dynamically load table numbers
                    StreamBuilder<List<int>>(
                      stream: tableNumbersStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButton<int>(
                            value: selectedTableNumber,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedTableNumber = newValue!;
                              });
                            },
                            items: snapshot.data!.map((tableNumber) {
                              return DropdownMenuItem<int>(
                                value: tableNumber,
                                child: Text('Table $tableNumber'),
                              );
                            }).toList(),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20.0),

            // Button to proceed with the payment
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Access the selected order type and table number
                  print('Selected Order Type: $selectedOrderType');
                  print('Selected Table Number: $selectedTableNumber');

                  // Add your payment logic here
                  // ...

                  // Close the popup
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  primary: Colors.teal,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  'Bayar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 10.0),

            // Button to cancel
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Access the selected order type and table number
                  print('Selected Order Type: $selectedOrderType');
                  print('Selected Table Number: $selectedTableNumber');

                  // Add your payment logic here
                  // ...

                  // Close the popup
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  'Batal',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}
