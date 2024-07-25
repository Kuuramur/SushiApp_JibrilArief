import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushi_mobile_app/models/food.dart';
import 'package:sushi_mobile_app/provider/cart.dart';
import 'package:sushi_mobile_app/screens/cart_screen.dart';

class DetailFood extends StatefulWidget {
  const DetailFood({
    super.key,
    required this.food,
  });

  final Food food;

  @override
  State<DetailFood> createState() => _DetailFoodState();
}

class _DetailFoodState extends State<DetailFood> {
  int quantityCount = 0;
  int costPayment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 10,
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                );
              },
              icon: Icon(
                CupertinoIcons.cart,
                size: 26,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                widget.food.imagePath.toString(),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.food.name.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Price",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.food.price} IDR',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.favorite_outline)
                    ],
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < 5; i++)
                        Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 243, 196, 41),
                        ),
                      SizedBox(width: 10),
                      Text(
                        '${widget.food.rating}',
                        style: TextStyle(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${widget.food.description}',
                    style: TextStyle(),
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            )
          ],
        ),
      ),

      //Bottom NavBar
      bottomNavigationBar: Container(
        height: 80,
        color: Color.fromARGB(255, 82, 18, 13),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(width: 8),
            FloatingActionButton(
              heroTag: 'q',
              backgroundColor: Colors.brown,
              elevation: 0,
              onPressed: () {
                setState(() {
                  quantityCount++;
                  costPayment =
                      quantityCount * int.parse(widget.food.price.toString());
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            FloatingActionButton(
                heroTag: 'w',
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: () {},
                child: Text(
                  quantityCount.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
            SizedBox(width: 8),
            FloatingActionButton(
              heroTag: 'rem',
              backgroundColor: Colors.brown,
              elevation: 0,
              onPressed: () {
                setState(() {
                  if (quantityCount > 0) {
                    quantityCount--;
                    costPayment =
                        quantityCount * int.parse(widget.food.price.toString());
                  }
                });
              },
              child: const Icon(
                Icons.remove,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(width: 8),
            Expanded(
              child: FloatingActionButton(
                heroTag: "t",
                backgroundColor: Colors.brown,
                elevation: 0,
                onPressed: () {
                  if (quantityCount > 0) {
                    final cart = context.read<Cart>();
                    cart.addToCart(widget.food, quantityCount);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "IDR $costPayment",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Add to Cart",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
