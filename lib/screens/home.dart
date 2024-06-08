import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:label_scanner/authentication/authentication.dart';
import 'package:label_scanner/authentication/login.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'; // Import for scanning
import 'package:label_scanner/screens/scan_product_screen.dart'; 
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? userName = 'Guest'; 

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          userName = user.displayName ?? 'Guest'; 
        });
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
    }
  }
  Future<void> scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    if (barcodeScanRes != '-1') {
      // Navigate to the ScanProductScreen and pass the EAN code
       if (!mounted) return;
       if (barcodeScanRes != '-1') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanProductScreen(ean: barcodeScanRes),
          ),
        );
      }
    } else {
      // Handle the case where the user denies camera permission
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Camera permission denied'),
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text('Label Scanner', style: TextStyle(color:Color.fromARGB(255, 255, 255, 255) ,fontSize: 24, fontWeight: FontWeight.w400)),
        backgroundColor:  Colors.deepPurple ,
        toolbarHeight: 45,
        actions: [
          TextButton(
            onPressed: () {
              AuthenticationHelper()
                  .signOut()
                  .then((_) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (contex) => const Login()),
                      ));
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
     body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hey $userName!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis, // Add this line
            ),
            const SizedBox(height: 50), // Add spacing
            ElevatedButton.icon(
              onPressed: scanBarcode, // Call the scanBarcode function on press
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
              label: const Text('Camera Scan', style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.deepPurple, // Customize button color
                textStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // This sets the initial selected tab to "Scan Product"
        onTap: (index) {
          if (index == 1) {
            // Navigate to Browse Scanned Products screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BrowseScannedProductsScreen()), // Replace with your actual screen
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

// Example browse screen (replace with your actual implementation)
class BrowseScannedProductsScreen extends StatelessWidget {
  const BrowseScannedProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: const Text('Browse Scanned Products', style: TextStyle(fontSize: 21)),
      ),  
      body: const Center(
        child: Text('Your scanned products will be listed here.'),
      ),
    );
  }
}