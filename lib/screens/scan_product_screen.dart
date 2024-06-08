import 'package:flutter/material.dart';

class ScanProductScreen extends StatelessWidget {
  final String ean;

  const ScanProductScreen({super.key, required this.ean});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Scanned EAN: $ean'),
            // Add UI for capturing product details and image uploads
          ],
        ),
      ),
    );
  }
}