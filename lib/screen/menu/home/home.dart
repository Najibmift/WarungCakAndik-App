import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app_flutter_1/components/food_card.dart';

class Home extends StatelessWidget {
  final CollectionReference sliderImagesCollection =
      FirebaseFirestore.instance.collection('slider');
  final String productId = 'bqJVNQzXcYYq3Ch3hpjw';
  final List<Map<String, dynamic>> popularFood = [];

  Home();

  Future<List<String>> _loadSliderImages() async {
    try {
      QuerySnapshot querySnapshot = await sliderImagesCollection.get();
      List<String> imageURLs =
          querySnapshot.docs.map((doc) => doc['image'].toString()).toList();
      return imageURLs;
    } catch (e) {
      print('Error loading slider images: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _loadPopularFood() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('/product/$productId/makanan/')
          .orderBy('clients', descending: true)
          .limit(5)
          .get();

      List<Map<String, dynamic>> popularFood = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return popularFood;
    } catch (e) {
      print('Error loading popular food: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> _loadBestFood() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('/product/$productId/makanan/')
          .orderBy('rate', descending: true)
          .limit(1)
          .get();

      Map<String, dynamic> bestFood =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return bestFood;
    } catch (e) {
      print('Error loading best food: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<List<String>>(
      future: _loadSliderImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error loading slider images: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No slider images available.');
        } else {
          List<String> imgSlider = snapshot.data!;

          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'What would you like to eat?',
                          style: TextStyle(fontSize: 21.0),
                        ),
                        Icon(Icons.notifications_none, size: 28.0)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                  ),
                  Container(
                    height: 150,
                    child: CarouselSlider(
                      items: imgSlider.map((imageUrls) {
                        return Container(
                          margin: EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.network(
                              imageUrls,
                              width: 10000,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 150,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 10.0, top: 20),
                    child: Text(
                      'Popular Food',
                      style: TextStyle(fontSize: 21.0),
                    ),
                  ),
                  Container(
                    height: 180.0,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _loadPopularFood(),
                      builder: (context, popularFoodSnapshot) {
                        if (popularFoodSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (popularFoodSnapshot.hasError) {
                          return Text(
                              'Error loading popular food: ${popularFoodSnapshot.error}');
                        } else if (!popularFoodSnapshot.hasData ||
                            popularFoodSnapshot.data!.isEmpty) {
                          return Text('No popular food available.');
                        } else {
                          popularFood.clear();
                          popularFood.addAll(popularFoodSnapshot.data!);

                          return ListView.builder(
                            padding: const EdgeInsets.only(left: 10.0),
                            scrollDirection: Axis.horizontal,
                            itemCount: popularFood.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> product = popularFood[index];
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
                                    width: size.width / 2 - 30.0,
                                    primaryColor: theme.primaryColor,
                                    productName: product['name'].toString(),
                                    productPrice: product['price'].toString(),
                                    productUrl: product['image'].toString(),
                                    productClients:
                                        product['clients'].toString(),
                                    productRate: product['rate'].toString(),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      bottom: 10.0,
                      top: 35.0,
                    ),
                    child: Text(
                      'Best Food',
                      style: TextStyle(fontSize: 21.0),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> bestFood = await _loadBestFood();
                      Navigator.pushNamed(context, 'details', arguments: {
                        'product': bestFood,
                        'index': popularFood.length,
                        'tag':
                            'detail_food_${popularFood.length}', // Unique tag for Hero
                      });
                    },
                    child: Hero(
                      tag:
                          'detail_food_${popularFood.length}', // Unique tag for Hero
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: _loadBestFood(),
                        builder: (context, bestFoodSnapshot) {
                          if (bestFoodSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (bestFoodSnapshot.hasError) {
                            return Text(
                                'Error loading best food: ${bestFoodSnapshot.error}');
                          } else if (!bestFoodSnapshot.hasData ||
                              bestFoodSnapshot.data!.isEmpty) {
                            return Text('No best food available.');
                          } else {
                            Map<String, dynamic> bestFood =
                                bestFoodSnapshot.data!;

                            return Container(
                              width: size.width - 40,
                              color: Colors.white,
                              padding: const EdgeInsets.only(bottom: 10.0),
                              margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                bottom: 15.0,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        height: size.width - 40,
                                        width: size.width - 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                bestFood['image'].toString()),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topRight,
                                        margin: const EdgeInsets.all(10.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Icons.favorite,
                                            size: 25.0,
                                            color: theme.primaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 4.0,
                                      left: 10.0,
                                      right: 10.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          bestFood['name'].toString(),
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade300,
                                                  blurRadius: 4.0,
                                                  offset: Offset(3.0, 3.0),
                                                )
                                              ]),
                                          child: Icon(
                                            Icons.near_me,
                                            size: 22.0,
                                            color: theme.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 10.0,
                                      right: 10.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          '${bestFood['rate']} (${bestFood['clients']})',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        Text(
                                          '\Rp. ${bestFood['price']}',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
