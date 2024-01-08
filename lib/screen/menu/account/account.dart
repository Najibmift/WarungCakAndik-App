import 'package:flutter/material.dart';
import 'package:my_app_flutter_1/components/food_card.dart';
import 'package:my_app_flutter_1/api/firebase_api.dart';
import 'package:my_app_flutter_1/screen/menu/account/get_profile.dart';
import 'package:my_app_flutter_1/services/authGate.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final GetProfileService _getProfileService = GetProfileService();
  late TabController _tabController;
  bool switchValue = true;
  late String _username = '';

  Future<void> _loadUsername() async {
    try {
      String? uid = await _authService.getCurrentUserUid();
      if (uid != null) {
        String? username = await _getProfileService.getUsername(uid);
        if (username != null) {
          setState(() {
            _username = username;
          });
        }
      }
    } catch (e) {
      print('Error loading username: $e');
    }
  }

  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _username = '';
    _loadUsername();
  }

  final List<Map<String, String>> favoriteFoods = [
    {
      'name': 'Tandoori Chicken',
      'price': '96.00',
      'rate': '4.9',
      'clients': '200',
      'image': 'lib/assets/logo.png'
    },
    {
      'name': 'Salmon',
      'price': '40.50',
      'rate': '4.5',
      'clients': '168',
      'image': 'lib/assets/logo.png'
    },
    {
      'name': 'Rice and meat',
      'price': '130.00',
      'rate': '4.8',
      'clients': '150',
      'image': 'lib/assets/logo.png'
    }
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Profile',
            style: TextStyle(fontSize: 30.0, color: Colors.teal),
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 30.0,
              bottom: 15.0,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 50.0,
              child: Icon(
                Icons.person,
                size: 40.0,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            _username,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.teal,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: theme.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: theme.primaryColor,
              labelStyle: TextStyle(fontSize: 24.0),
              unselectedLabelColor: Colors.black,
              tabs: <Widget>[
                Tab(text: 'Your Favorite'),
                Tab(text: 'Account Setting'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Container(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: ((size.width / 2) / 230),
                    children: this.favoriteFoods.map((product) {
                      return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: FoodCard(
                          width: size.width,
                          primaryColor: theme.primaryColor,
                          productName: product['name']!,
                          productPrice: product['price']!,
                          productUrl: product['image']!,
                          productClients: product['clients']!,
                          productRate: product['rate']!,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.person_2_outlined,
                                size: 30.0,
                                color: theme.primaryColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: Text(
                                  'Change Profile',
                                  style: TextStyle(fontSize: 24.0),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade100,
                              ),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.email_outlined,
                                size: 30.0,
                                color: theme.primaryColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: Text(
                                  'Change Email',
                                  style: TextStyle(fontSize: 24.0),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.key,
                                size: 30.0,
                                color: theme.primaryColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(fontSize: 24.0),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade100,
                              ),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.food_bank_outlined,
                                size: 30.0,
                                color: theme.primaryColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: Text(
                                  'Your Favorite',
                                  style: TextStyle(fontSize: 24.0),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 65.0),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.power_settings_new,
                                size: 30.0,
                                color: theme.primaryColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    await AuthService().signOut();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AuthGate(),
                                        ));
                                  },
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(fontSize: 24.0),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
