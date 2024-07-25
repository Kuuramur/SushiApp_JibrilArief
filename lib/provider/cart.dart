import 'package:flutter/material.dart';
import 'package:sushi_mobile_app/models/cart_model.dart';
import 'package:sushi_mobile_app/models/food.dart';

class Cart extends ChangeNotifier {
  final List<CartModel> _cart = [];

  List<CartModel> get cart => _cart;

  void addToCart(Food food, int qty) {
    _cart.add(
      CartModel(
        name: food.name,
        price: food.price,
        imagePath: food.imagePath,
        quantity: qty.toString(),
      ),
    );
    notifyListeners();
  }

  void removeFromCart(CartModel item) {
    _cart.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
