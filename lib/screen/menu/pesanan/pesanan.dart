import 'package:flutter/material.dart';
import 'package:my_app_flutter_1/api/firebase_api.dart';
import 'package:my_app_flutter_1/components/custom_header.dart';
import 'package:my_app_flutter_1/screen/menu/pesanan/cart_provider.dart';
import 'package:my_app_flutter_1/screen/menu/pesanan/checkout.dart';
import 'package:provider/provider.dart';

class Pesanan extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Pesanan> with TickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();

  void showCheckoutPopup(double totalPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CheckoutPopup(totalPrice: totalPrice);
      },
    );
  }

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
                                image: NetworkImage(food['image']!),
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
                                  Text('\Rp. ${food['price']}'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.remove,
                                            color: Colors.red),
                                        onPressed: () async {
                                          if (quantity > 0) {
                                            cartProvider.updateLocalQuantity(
                                                index, quantity - 1);

                                            // Update quantity in the Firestore database in the background
                                            cartProvider.updateQuantity(
                                                userId!, index, quantity - 1);
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
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.teal,
                                          ),
                                          onPressed: () {
                                            cartProvider.updateLocalQuantity(
                                                index, quantity + 1);

                                            // Update quantity in the Firestore database in the background
                                            cartProvider.updateQuantity(
                                                userId!, index, quantity + 1);
                                          }),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  double totalPrice = cartProvider.calculateTotalPrice();
                  // Show the CheckoutPopup when the button is pressed
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CheckoutPopup(totalPrice: totalPrice);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 35.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  primary: Colors.teal,
                ),
                child: Text(
                  'CHECKOUT',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
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
          return SingleChildScrollView(
            child: Container(
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
                              image: NetworkImage(food['image']!),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                                Text('\Rp. ${food['price']}'),
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
                            image: NetworkImage(food['image']!),
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
                              Text('\Rp. ${food['price']}'.toString()),
                              Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(food['rate']!.toString()),
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
                    ],
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: size.height *
                              0.20 *
                              cartProvider.cartItems.length,
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
                  ),
                  renderDoneOrder(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
