// new_screen.dart
import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  final String productId;

  // Constructor to accept the productId
  NewScreen({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
      ),
      body: Center(
        child: Text(
          'Product ID: $productId', // Display the product ID
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
