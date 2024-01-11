import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TableStatus { empty, reserved, occupied }

class Monitoring extends StatefulWidget {
  @override
  _MonitorState createState() => _MonitorState();
}

class _MonitorState extends State<Monitoring> {
  late FirebaseFirestore _firestore;
  List<TableStatus> tableStatusList =
      List.generate(14, (index) => TableStatus.empty);

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _fetchTableData();
  }

  Future<void> _fetchTableData() async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('meja').doc('1AZnugeof9l54dz6sbaB').get();

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      for (int i = 1; i <= 14; i++) {
        int level = data['meja_$i']['level'];
        setState(() {
          switch (level) {
            case 0:
              tableStatusList[i - 1] = TableStatus.empty;
              break;
            case 1:
              tableStatusList[i - 1] = TableStatus.reserved;
              break;
            case 2:
              tableStatusList[i - 1] = TableStatus.occupied;
              break;
          }
        });
      }
    } catch (e) {
      print('Error fetching table data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table Monitor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: 14,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _updateTableStatus(index + 1);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _getColorForTableStatus(tableStatusList[index]),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Meja No. ${index + 1}',
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

  Color _getColorForTableStatus(TableStatus status) {
    switch (status) {
      case TableStatus.empty:
        return Colors.green;
      case TableStatus.reserved:
        return Colors.yellow;
      case TableStatus.occupied:
        return Colors.red;
    }
  }

  Future<void> _updateTableStatus(int tableNumber) async {
    try {
      int index = tableNumber - 1;
      int newLevel = (tableStatusList[index] == TableStatus.occupied)
          ? 0
          : tableStatusList[index].index + 1;

      await _firestore.collection('meja').doc('1AZnugeof9l54dz6sbaB').update({
        'meja_$tableNumber': {'level': newLevel},
      });

      setState(() {
        switch (newLevel) {
          case 0:
            tableStatusList[index] = TableStatus.empty;
            break;
          case 1:
            tableStatusList[index] = TableStatus.reserved;
            break;
          case 2:
            tableStatusList[index] = TableStatus.occupied;
            break;
        }
      });
    } catch (e) {
      print('Error updating table status: $e');
    }
  }
}
