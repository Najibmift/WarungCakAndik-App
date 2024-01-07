import 'package:flutter/material.dart';
import 'package:my_app_flutter_1/api/firebase_api.dart';
import 'package:my_app_flutter_1/components/custom_header.dart';
import 'package:my_app_flutter_1/screen/menu/pesanan/cart_provider.dart';
import 'package:provider/provider.dart';
import 'cart_service.dart';

Widget iconBadge({required IconData icon, required Color iconColor}) {
  return Container(
    padding: const EdgeInsets.all(4.0),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4.0,
          offset: Offset(3.0, 3.0),
        )
      ],
      shape: BoxShape.circle,
      color: Colors.white,
    ),
    child: Icon(
      icon,
      size: 20.0,
      color: iconColor,
    ),
  );
}

Widget detailsTab() {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          child: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut enim leo. In sagittis velit nibh. Morbi sollicitudin lorem vitae nisi iaculis,sit amet suscipit orci mollis. Ut dictum lectus eget diam vestibulum, at eleifend felis mattis. Sed molestie congue magna at venenatis. In mollis felis ut consectetur consequat.',
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          color: Color.fromRGBO(250, 250, 250, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Icon(
                    Icons.history,
                    color: Colors.blue[900],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('12am - 3pm'),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Icon(
                    Icons.gps_fixed,
                    color: Colors.green[300],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('3.54 km'),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Icon(
                    Icons.map,
                    color: Colors.redAccent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Map view'),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Icon(
                    Icons.directions_walk,
                    color: Colors.deepOrange,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Delivery'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget renderCardReview() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            CircleAvatar(
              child: Icon(Icons.person),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Person',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'December 14, 2019',
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 50.0,
            top: 2.0,
          ),
          child: Text(
            'Cras ac nunc pretium, lacinia lorem ut, congue metus. Aenean vitae lectus at mauris eleifend placerat. Proin a nisl ut risus euismod ultrices et sed dui.',
            style: TextStyle(
              fontSize: 13.0,
            ),
          ),
        )
      ],
    ),
  );
}

Widget reviewTab() {
  return SingleChildScrollView(
    child: Container(
      child: Column(
        children: <Widget>[
          renderCardReview(),
          renderCardReview(),
          renderCardReview(),
          renderCardReview(),
        ],
      ),
    ),
  );
}

class BodyDetails extends StatefulWidget {
  @override
  _BodyDetailsState createState() => _BodyDetailsState();
}

class _BodyDetailsState extends State<BodyDetails>
    with TickerProviderStateMixin {
  int quantity = 0;
  int screenTab = 0;
  late TabController _tabController;
  TextEditingController _textEditingController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    this._tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map screenArguments =
        ModalRoute.of(context)?.settings.arguments as Map;
    Map product = screenArguments['product']!;
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CustomHeader(
            title: '',
            quantity: this.quantity,
            internalScreen: true,
          ),
          Container(
            margin: EdgeInsets.only(
              top: size.width * 0.55,
              left: 50.0,
              right: 50.0,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 65.0, bottom: 10.0),
            child: iconBadge(
              icon: Icons.favorite,
              iconColor: theme.primaryColor,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              width: size.width - 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        iconBadge(
                          icon: Icons.near_me,
                          iconColor: theme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            product['name'],
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Text(
                            '\$ ${product['price']}',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'by',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(' Restaurant'),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (quantity > 0) {
                              setState(() {
                                quantity--;
                                _textEditingController.text =
                                    quantity.toString();
                              });
                            }
                          },
                          child: Icon(
                            Icons.remove,
                            size: 30.0,
                            color: Colors.red,
                          ),
                        ),
                        Container(
                          width: 50.0,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            controller:
                                _textEditingController, // Gunakan controller
                            onChanged: (value) {
                              // Handle onChanged event
                              if (value.isEmpty) {
                                setState(() {
                                  _textEditingController.value =
                                      TextEditingValue(
                                    text: '0',
                                    selection:
                                        TextSelection.collapsed(offset: 1),
                                  );
                                });
                              } else if (value.isNotEmpty) {
                                int parsedValue = int.parse(value);
                                setState(() {
                                  quantity = parsedValue;
                                  _textEditingController.value =
                                      _textEditingController.value.copyWith(
                                    text: parsedValue.toString(),
                                    selection: TextSelection.collapsed(
                                        offset: value.length),
                                  );
                                });
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 5.0),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              quantity++;
                              _textEditingController.text = quantity.toString();
                            });
                          },
                          child: Icon(
                            Icons.add,
                            size: 30.0,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width - 200.0,
                    margin: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        CartProvider cartProvider =
                            Provider.of<CartProvider>(context, listen: false);
                        cartProvider.addToCart(product.cast<String, dynamic>());
                        String? uid = _authService.getCurrentUserUid();
                        FirestoreService firestoreService = FirestoreService();
                        await firestoreService.addToCart(
                            uid!, product.cast<String, dynamic>());
                      },
                      style: ElevatedButton.styleFrom(
                        primary: theme.primaryColor,
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TabBar(
                      controller: this._tabController,
                      labelColor: theme.primaryColor,
                      labelPadding: EdgeInsets.all(0),
                      indicatorColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                      ),
                      tabs: [
                        Container(
                          height: 25.0,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'DETAILES',
                          ),
                        ),
                        Container(
                          height: 25.0,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Review',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: this._tabController,
                      children: [
                        detailsTab(),
                        reviewTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
