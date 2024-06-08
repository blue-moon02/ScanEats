// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> productData;

  const ProductDetailsScreen({super.key, required this.productData});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product? _product;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'Label Scanner'); // Set UserAgent here
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final ProductQueryConfiguration configuration = ProductQueryConfiguration(
        widget.productData['ean'],
        language: OpenFoodFactsLanguage.ENGLISH,
        fields: [ProductField.ALL],
        version: ProductQueryVersion.v3,
      );

      final ProductResultV3 result = await OpenFoodAPIClient.getProductV3(configuration);
  

      // Handle potential errors
      if (result.status != ProductResultV3.statusSuccess || result.product == null) {
        throw Exception('Failed to fetch product details');
      }

      setState(() {
        _product = result.product;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching more product details: $e');

      
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch more product details')),
      );

      
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product?.productName ?? 'Product Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Product Details in a Card (for visual grouping)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8), // Add some spacing
                          Text('EAN: ${widget.productData['ean']}', style: const TextStyle(fontSize:16),),
                          Text(
                            'Scanned on: ${widget.productData['scanDate'].toDate()}',
                            style: TextStyle(color: Colors.grey[600]), // Slightly de-emphasize
                          ),
                          const Divider(), // Add a divider for clarity
                          // Data from Open Food Facts (if available)
                          if (_product != null) ...[
                            ListTile(
                              title: Text(
                                  'Product Name: ${_product!.productName?? "Unknown"}'),
                            ),
                            ListTile(
                              title: Text('Brand: ${_product!.brands ?? "Unknown"}'),
                            ),
                            if (_product!.ingredientsText != null)
                              ListTile(
                                title:
                                    Text('Ingredients: ${_product!.ingredientsText}'),
                              ),
                            // ...Add more fields as needed (nutrients, etc.)
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text('Barcode Image :',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  Hero(
                    tag: 'barcodeImage-${widget.productData['ean']}',
                    child: CachedNetworkImage(
                      imageUrl: widget.productData['barcodeImageUrl'],
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  Text('Ingedients Image :',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), ),
                  Hero(
                    tag: 'ingredientsImage-${widget.productData['ean']}',
                    child: CachedNetworkImage(
                      imageUrl: widget.productData['ingredientsImageUrl'],
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),

                ],
              ),
            ),
    );
  }
}