import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushi_mobile_app/provider/cart.dart';
import 'package:sushi_mobile_app/screens/home_screen.dart';
import 'package:sushi_mobile_app/screens/payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double price = 0;
    double totalPrice = 0;
    double taxAndService = 0;
    double totalPayment = 0;

    return Consumer<Cart>(
      builder: (context, value, child) {
        for (var cartModel in value.cart) {
          price = int.parse(cartModel.quantity.toString()) *
              int.parse(cartModel.price.toString()).toDouble();
          totalPrice += double.parse(price.toString());
          taxAndService = (totalPrice * 0.11).toDouble();
          totalPayment = totalPrice + taxAndService.toDouble();
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Cart"),
          ),
          body: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: value.cart.length,
                itemBuilder: (context, index) {
                  final food = value.cart[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset(
                        food.imagePath.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(food.name.toString()),
                    subtitle: Text("${food.quantity} x ${food.price} IDR"),
                    trailing: IconButton(
                      onPressed: () {
                        value.removeFromCart(food);
                        if (value.cart.isEmpty) {
                          price = 0;
                          totalPrice = 0;
                          taxAndService = 0;
                          totalPayment = 0;
                        } else {
                          context.read<Cart>();
                        }
                      },
                      icon: Icon(
                        CupertinoIcons.minus_circle,
                      ),
                    ),
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Text("Add more food"),
              )
            ],
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(8),
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Price"),
                          Text("IDR $totalPrice"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tax and Service"),
                          Text("IDR $taxAndService"),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Price",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "IDR $totalPayment",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                CupertinoButton(
                  color: Color.fromARGB(255, 82, 18, 13),
                  padding: const EdgeInsets.all(20),
                  borderRadius: BorderRadius.circular(30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payment",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
