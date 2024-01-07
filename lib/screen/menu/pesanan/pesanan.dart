import 'package:flutter/material.dart';
import 'package:my_app_flutter_1/api/firebase_api.dart';
import 'package:my_app_flutter_1/components/custom_header.dart';
import 'package:my_app_flutter_1/screen/menu/pesanan/cart_provider.dart';
import 'package:provider/provider.dart';

class Pesanan extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Pesanan> with TickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();
  // final List<Map<String, String>> foods = [
  //   {
  //     'name': 'Rice and meat',
  //     'price': '130.00',
  //     'rate': '4.8',
  //     'clients': '150',
  //     'image': 'lib/assets/logo.png'
  //   },
  //   {
  //     'name': 'Vegan food',
  //     'price': '400.00',
  //     'rate': '4.2',
  //     'clients': '150',
  //     'image': 'lib/assets/logo.png'
  //   },
  // ];

  @override
  void initState() {
    this._tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    // Fetch cart data when the widget is created
    String? userId = _authService.getCurrentUserUid();
    if (userId != null) {
      Provider.of<CartProvider>(context, listen: false).fetchCartData(userId);
    }
    super.initState();
  }

  Widget renderAddList() {
    String? userId = _authService.getCurrentUserUid();
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Stack(
          children: [
            ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                Map<dynamic, dynamic> food = cartProvider.cartItems[index];
                Color primaryColor = Theme.of(context).primaryColor;
                int quantity = food['quantity'] ?? 0; // Jumlah produk

                return Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: Hero(
                    tag: 'detail_food$index',
                    child: Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(food['image']!),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(food['name']!),
                                      IconButton(
                                        icon: cartProvider.isLoading
                                            ? Container() // Empty container when loading
                                            : Icon(Icons.delete_outline),
                                        onPressed: cartProvider.isLoading
                                            ? null
                                            : () async {
                                                if (userId != null) {
                                                  await cartProvider
                                                      .removeItemFromFirestore(
                                                          userId, index);
                                                } else {
                                                  print(
                                                      'Error: userId is null.');
                                                }
                                              },
                                      ),
                                    ],
                                  ),
                                  Text('\$${food['price']}'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          if (quantity > 0) {
                                            // Update quantity in the cart
                                            cartProvider.updateQuantity(
                                                index, quantity - 1);
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 50.0,
                                        child: Center(
                                          child: Text(
                                            quantity.toString(),
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          // Update quantity in the cart
                                          cartProvider.updateQuantity(
                                              index, quantity + 1);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            if (cartProvider.isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }

  Widget renderTracking() {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      return ListView.builder(
        itemCount: cartProvider.cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          Map<dynamic, dynamic> food = cartProvider.cartItems[index];
          Color primaryColor = Theme.of(context).primaryColor;
          return Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  'details',
                  arguments: {
                    'product': food,
                    'index': index,
                  },
                );
              },
              child: Hero(
                tag: 'detail_food$index',
                child: Card(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(food['image']!),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(food['name']!),
                                    Text(
                                      'Item-2',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                              Text('\$${food['price']}'),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'View Detail',
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget renderDoneOrder() {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      return ListView.builder(
        itemCount: cartProvider.cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          Map<dynamic, dynamic> food = cartProvider.cartItems[index];
          Color primaryColor = Theme.of(context).primaryColor;
          return Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  'details',
                  arguments: {
                    'product': food,
                    'index': index,
                  },
                );
              },
              child: Hero(
                tag: 'detail_food$index',
                child: Card(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(food['image']!),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(food['name']!),
                              ),
                              Text('\$${food['price']}'),
                              Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(food['rate']!),
                                      Text(
                                        'Give your review',
                                        style: TextStyle(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        children: <Widget>[
          CustomHeader(
            title: 'Cart Food',
            quantity: cartProvider.cartItems.length,
            internalScreen: false,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10.0,
            ),
            child: TabBar(
              controller: this._tabController,
              indicatorColor: theme.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black87,
              tabs: <Widget>[
                Tab(text: 'Add Food'),
                Tab(text: 'Tracking Order'),
                Tab(text: 'Done Order'),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TabBarView(
                controller: this._tabController,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: this.renderAddList(),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 35.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: theme.primaryColor,
                        ),
                        child: Text(
                          'CHECKOUT',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height:
                            size.height * 0.20 * cartProvider.cartItems.length,
                        width: size.width,
                        child: this.renderTracking(),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 65.0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 35.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: theme.primaryColor,
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.location_searching,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'View Tracking Order',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  this.renderDoneOrder(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
