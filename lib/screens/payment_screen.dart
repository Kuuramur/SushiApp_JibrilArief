import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sushi_mobile_app/provider/cart.dart';
import 'package:sushi_mobile_app/screens/home_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;
  String _virtualAccountNumber = '';

  @override
  void initState() {
    super.initState();
    _generateVirtualAccountNumber();
  }

  void _generateVirtualAccountNumber() {
    final random = Random();
    _virtualAccountNumber = List.generate(10, (_) => random.nextInt(10)).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          double totalPrice = 0;
          int totalItems = 0;
          for (var item in cart.cart) {
            int quantity = int.tryParse(item.quantity ?? '0') ?? 0;
            double price = double.tryParse(item.price ?? '0') ?? 0.0;
            totalPrice += quantity * price;
            totalItems += quantity;
          }
          double taxAndService = totalPrice * 0.11;
          double totalPayment = totalPrice + taxAndService;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Summary',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                _buildSummaryRow('Total Items:', '$totalItems'),
                _buildSummaryRow('Total Price:', 'IDR $totalPrice'),
                _buildSummaryRow('Tax and Service:', 'IDR $taxAndService'),
                Divider(),
                _buildSummaryRow(
                  'Total Payment:',
                  'IDR $totalPayment',
                  isBold: true,
                ),
                SizedBox(height: 20),
                Text(
                  'Choose Payment Method',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ListTile(
                  title: const Text('E-Wallet'),
                  leading: Radio<String>(
                    value: 'E-Wallet',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                        _generateVirtualAccountNumber();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Bank Transfer'),
                  leading: Radio<String>(
                    value: 'Bank Transfer',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                        _generateVirtualAccountNumber();
                      });
                    },
                  ),
                ),
                if (_selectedPaymentMethod != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Virtual Account Number: $_virtualAccountNumber',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: _virtualAccountNumber),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Copied to clipboard')),
                              );
                            },
                            icon: Icon(Icons.copy),
                            label: Text('Copy'),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            cart.clearCart();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 142, 182, 24),
                            padding: EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: Text(
                            'Checkout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
