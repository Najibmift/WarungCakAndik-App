import 'package:flutter/material.dart';

enum TableStatus { empty, reserved, occupied }

class Monitoring extends StatefulWidget {
  @override
  _MonitorState createState() => _MonitorState();
}

class _MonitorState extends State<Monitoring> {
  List<TableStatus> tableStatusList =
      List.generate(14, (index) => TableStatus.empty);

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
                // Change the table status cyclically
                setState(() {
                  switch (tableStatusList[index]) {
                    case TableStatus.empty:
                      tableStatusList[index] = TableStatus.reserved;
                      break;
                    case TableStatus.reserved:
                      tableStatusList[index] = TableStatus.occupied;
                      break;
                    case TableStatus.occupied:
                      tableStatusList[index] = TableStatus.empty;
                      break;
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _getColorForTableStatus(tableStatusList[index]),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Table ${index + 1}',
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
}
