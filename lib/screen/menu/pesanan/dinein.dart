import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DineInTableSelection extends StatefulWidget {
  @override
  _DineInTableSelectionState createState() => _DineInTableSelectionState();
}

class _DineInTableSelectionState extends State<DineInTableSelection> {
  late FirebaseFirestore _firestore;
  List<int> availableTables = [];

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _fetchAvailableTables();
  }

  Future<void> _fetchAvailableTables() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('meja')
          .where('level', isEqualTo: 0) // Filter for empty tables
          .get();

      setState(() {
        availableTables =
            querySnapshot.docs.map((doc) => int.parse(doc.id)).toList();
      });
    } catch (e) {
      print('Error fetching available tables: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dine In - Select Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: availableTables.length,
          itemBuilder: (context, index) {
            int tableNumber = availableTables[index];
            return GestureDetector(
              onTap: () {
                // Handle table selection for dine-in
                // You may want to pass the selected table information back to the Pesanan screen
                // For simplicity, here, we just print the selected table number.
                print('Selected Table: $tableNumber for Dine In');
                Navigator.pop(context); // Close the dialog
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors
                      .green, // You can customize the color for available tables
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Meja No. $tableNumber',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
