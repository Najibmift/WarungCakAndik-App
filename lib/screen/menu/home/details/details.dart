import 'package:flutter/material.dart';
import 'package:my_app_flutter_1/screen/menu/home/details/body_details.dart';

class Details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Map? screenArguments =
        ModalRoute.of(context)?.settings.arguments as Map?;

    // Check if screenArguments is not null before accessing its properties
    if (screenArguments == null) {
      // Handle the case where screenArguments is null, for example, navigate back or show an error message.
      return Scaffold(
        body: Center(
          child: Text("Error: Missing screen arguments"),
        ),
      );
    }

    Map product = screenArguments['product'];
    int index = screenArguments['index'];

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: 'detail_food$index',
            child: Container(
              alignment: Alignment.topCenter,
              width: size.width,
              height: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(product['image']),
                ),
              ),
            ),
          ),
          BodyDetails(),
        ],
      ),
    );
  }
}
