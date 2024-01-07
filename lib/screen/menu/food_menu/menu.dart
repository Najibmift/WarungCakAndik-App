import 'package:flutter/material.dart';
import 'package:my_app_flutter_1/components/food_card.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // Define two lists for food and drinks
  final List<Map<String, String>> foodList = [
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
    },
  ]; // Your food list
  final List<Map<String, String>> drinkList = [
    {
      'name': 'Vegan food',
      'price': '400.00',
      'rate': '4.2',
      'clients': '150',
      'image': 'lib/assets/logo.png'
    },
    {
      'name': 'Rich food',
      'price': '1000.00',
      'rate': '4.6',
      'clients': '10',
      'image': 'lib/assets/logo.png'
    }
  ]; // Your drink list

  int _selectedTabIndex = 0; // 0 for food, 1 for drinks

  List<Map<String, String>> get selectedCategoryList =>
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
                    Map<String, String> product = selectedCategoryList[index];
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
                          productName: product['name']!,
                          productPrice: product['price']!,
                          productUrl: product['image']!,
                          productClients: product['clients']!,
                          productRate: product['rate']!,
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
