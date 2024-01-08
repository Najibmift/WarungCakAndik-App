import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:my_app_flutter_1/screen/menu/home/home.dart';
import 'package:my_app_flutter_1/screen/menu/account/account.dart';
import 'package:my_app_flutter_1/screen/menu/monitor/monitor.dart';
import 'package:my_app_flutter_1/screen/menu/pesanan/pesanan.dart';
import 'package:my_app_flutter_1/screen/menu/home/details/details.dart';
import 'package:my_app_flutter_1/screen/menu/food_menu/menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Bottom Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      routes: {
        'details': (context) => Details(),
      },
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: MyHomePage(title: 'circular_bottom_navigation'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPos = 0;

  double bottomNavBarHeight = 60;

  List<TabItem> tabItems = List.of([
    TabItem(
      Icons.home,
      "Home",
      Colors.teal,
      labelStyle: TextStyle(
        color: Colors.teal,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      Icons.fastfood_outlined,
      "Menu",
      Colors.teal,
      labelStyle: TextStyle(
        color: Colors.teal,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      Icons.table_restaurant_rounded,
      "Table Monitor",
      Colors.teal,
      labelStyle: TextStyle(
        color: Colors.teal,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      Icons.border_color,
      "Pesanan",
      Colors.teal,
      labelStyle: TextStyle(
        color: Colors.teal,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      Icons.person,
      "Profile",
      Colors.teal,
      labelStyle: TextStyle(
        color: Colors.teal,
        fontWeight: FontWeight.bold,
      ),
    ),
  ]);

  late CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            child: bodyContainer(),
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer() {
    Color? selectedColor = tabItems[selectedPos].circleColor;
    String slogan;
    IconData icon;
    switch (selectedPos) {
      case 0:
        return Home();
      case 1:
        return Menu();
      case 2:
        return Monitoring();
      case 3:
        return Pesanan();
      case 4:
        return Account();
      default:
        slogan = "";
        icon = Icons.home;
        break;
    }

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: selectedColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                slogan,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        if (_navigationController.value == tabItems.length - 1) {
          _navigationController.value = 0;
        } else {
          _navigationController.value = _navigationController.value! + 1;
        }
      },
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      selectedPos: selectedPos,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      backgroundBoxShadow: <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        setState(() {
          this.selectedPos = selectedPos ?? 0;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}
