import 'package:flutter/material.dart';
import 'package:my_app_flutter_1/components/food_card.dart';
import 'menu_service.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final MenuFirestoreService firestoreService = MenuFirestoreService();
  List<Map<String, dynamic>> foodList = [];
  List<Map<String, dynamic>> drinkList = [];
  int _selectedTabIndex = 0; // 0 for food, 1 for drinks

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      String productId =
          "bqJVNQzXcYYq3Ch3hpjw"; // Replace with the actual productId

      foodList = await firestoreService.getFoodList(productId);
      drinkList = await firestoreService.getDrinkList(productId);

      setState(() {});
      print(drinkList);
      print(foodList);
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  List<Map<String, dynamic>> get selectedCategoryList =>
      _selectedTabIndex == 0 ? foodList : drinkList;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      initialIndex: _selectedTabIndex,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text('What would you like to eat?'),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications_none),
                  onPressed: () {
                    // Handle notifications button tap
                  },
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Food'),
                  Tab(text: 'Drinks'),
                ],
                onTap: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
              ),
              floating: true,
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: selectedCategoryList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Map<String, dynamic> product = selectedCategoryList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'details',
                          arguments: {
                            'product': product,
                            'index': index,
                          },
                        );
                      },
                      child: Hero(
                        tag: 'detail_food$index',
                        child: FoodCard(
                          width: (size.width - 60.0) / 2,
                          primaryColor: theme.primaryColor,
                          productName: product['name'].toString(),
                          productPrice: product['price'].toString(),
                          productUrl: product['image'].toString(),
                          productClients: product['clients'].toString(),
                          productRate: product['rate'].toString(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
