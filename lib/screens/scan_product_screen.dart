import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:label_scanner/screens/home.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanProductScreen extends StatefulWidget {
  final String ean;
  const ScanProductScreen({super.key, required this.ean});

  @override
  State<ScanProductScreen> createState() => _ScanProductScreenState();
}

class _ScanProductScreenState extends State<ScanProductScreen> {
  File? _barcodeImage;
  File? _ingredientsImage;
  bool _isLoading = false;
  final _firestore = FirebaseFirestore.instance;

  Future<void> _pickImage(ImageSource source, bool isBarcode) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      if (isBarcode) {
        final barcode = await _scanBarcode(File(pickedFile.path)); // Call _scanBarcode instead of scanner.analyzeImage
        if (barcode != null) {
          setState(() {
            _barcodeImage = File(pickedFile.path);
          });
        } else {
          // No barcode detected - show error message
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please upload a barcode image or try taking a clear picture')),
          );
        }
      } else {
        // Ingredients image - no validation needed
        setState(() {
          _ingredientsImage = File(pickedFile.path);
        });
      }
    }
  }

  Future<Barcode?> _scanBarcode(File imageFile) async {
    final MobileScannerController controller = MobileScannerController();

    try {
      final barcode = await controller.analyzeImage(imageFile.path);

      if (barcode != null && barcode.barcodes.isNotEmpty) { // Added null checks here
        // Return the first barcode found (you can add logic to choose the best one if needed)
        return barcode.barcodes[0];
      }
    } catch (e) {
      debugPrint('Error scanning barcode from image: $e');
    } finally {
      controller.dispose(); // Dispose the controller in the finally block
    }

    return null; // No valid EAN found
  }
  


  Future<void> _saveProductDetails() async {
    if (_barcodeImage == null || _ingredientsImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select and upload the images')),
      );
      return;
    }
  
    setState(() {
      _isLoading = true;
    });

    try {
      final firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Upload images and get download URLs
      final barcodeUploadTask =
          storageRef.child('barcodes/${widget.ean}.jpg').putFile(_barcodeImage!);
      final ingredientsUploadTask = storageRef
          .child('ingredients/${widget.ean}.jpg')
          .putFile(_ingredientsImage!);

      final barcodeImageUrl =
          await (await barcodeUploadTask).ref.getDownloadURL();
      final ingredientsImageUrl =
          await (await ingredientsUploadTask).ref.getDownloadURL();

      // Create a map to store product details
      final productData = {
        'ean': widget.ean,
        'scanDate': DateTime.now(),
        'barcodeImageUrl': barcodeImageUrl,
        'ingredientsImageUrl': ingredientsImageUrl,
        'userId': user.uid, 
      };

      await _firestore.collection('products').doc(widget.ean).set(productData);

      // Successfully saved data. Now we want to navigate to HomeScreen

      if (!mounted) return;

      // Navigate back to Home screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } 
      setState(() {
        _isLoading = false;
      });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details', style: TextStyle(color: Colors.white, fontSize: 21)),
        backgroundColor: Colors.deepPurple,
        toolbarHeight: 50,
      ),
      
      body:  Stack( // Use a Stack to overlay the button
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 4), 
                 Text('Scanned EAN: ${widget.ean}', 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize:16)),
                  
                  
                
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera, true),
                  child: const Text('Take Picture of Barcode',style: TextStyle(fontWeight: FontWeight.bold, fontSize:15),),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera, false),
                  child: const Text('Take Picture of Ingredients',style: TextStyle(fontWeight: FontWeight.bold, fontSize:15),),
                ),
                const SizedBox(height: 20), // Add spacing
                // Wrap images in a LimitedBox with max height for overflow control
                LimitedBox(
                  maxHeight: MediaQuery.of(context).size.height * 0.4, // Use a fraction of screen height
                  child: Column(
                    children: [
                      if (_barcodeImage != null) 
                        Expanded(
                          child: Image.file(_barcodeImage!),),
                      if (_ingredientsImage != null) 
                        Expanded(
                          child: Image.file(_ingredientsImage!),),
                    ],
                  ),
                ),
                const Spacer(), // Push the button to the bottom
              ],
            ),
          ),
          if (!_isLoading) 
            Positioned( // Position the button at the bottom
              bottom: 16,
              left: 45,
              right: 45,
              child: ElevatedButton(
                onPressed: _saveProductDetails,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // Set a minimum height for the button
                  backgroundColor: const Color.fromARGB(255, 244, 243, 244)
                ),
                child: const Text('Proceed',style: TextStyle(fontWeight: FontWeight.bold, fontSize:20),),
                
              ),
            ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}