import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:label_scanner/screens/home.dart';
import 'package:label_scanner/screens/product_details_screen.dart';



class BrowseScannedProductsScreen extends StatefulWidget {
  const BrowseScannedProductsScreen({super.key});

  @override
  State<BrowseScannedProductsScreen> createState() => _BrowseScannedProductsScreenState();
}

class _BrowseScannedProductsScreenState extends State<BrowseScannedProductsScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance; // For current user's ID
  String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned Products', style: TextStyle(color: Colors.white, fontSize: 21),),
        backgroundColor: Colors.deepPurple,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by Product EAN', // You can search by product name here as well
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('products')
            .where('userId', isEqualTo: _auth.currentUser?.uid) // Filter by user ID
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) { // Check if empty list
            return const Center(child: Text('No products scanned yet'));
          }
          final productDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: productDocs.length,
            itemBuilder: (context, index) {
              final productData =
                  productDocs[index].data() as Map<String, dynamic>;
              final ean = productData['ean'];
           // Filter by search query
                  if (_searchQuery.isNotEmpty &&
                      !ean.contains(_searchQuery)) { 
                    return Container(); // Don't show this item
                  }
          
              return ListTile(
                leading: Image.network(productData['barcodeImageUrl'], height: 50, width: 50, fit: BoxFit.cover),
                title: Text('EAN: ${productData['ean']}'),
                subtitle: Text('Scanned on: ${productData['scanDate'].toDate().toString()}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(productData: productData),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1, // This sets the initial selected tab to "Scan Product"
          onTap: (index) {
            if (index == 0) {
              // Navigate to Browse Scanned Products screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()), // Replace with your actual screen
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Scan Product',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Browse',
            ),
          ],
        ),
    );
  }
}
