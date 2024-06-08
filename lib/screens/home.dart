import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:label_scanner/authentication/authentication.dart';
import 'package:label_scanner/authentication/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            userName = userData['name'] ?? 'Guest'; // Use null-aware operator for safety
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text('Label Scanner', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
        backgroundColor: const Color.fromARGB(255, 173, 107, 230),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Adjust padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  // TO_DO: Implement QR scanning logic
                },
                icon: const Icon(Icons.qr_code_scanner,color: Colors.white, size: 32),
                label: const Text('Scan Products', style: TextStyle(fontSize: 18,color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.deepPurple, // Customize button color
                  textStyle: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30), // Add space between buttons
              ElevatedButton(
                onPressed: () {
                  // TO_DO: Implement navigation to browse scanned products screen
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  backgroundColor: Colors.amber, // Customize button color
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child: const Text('Browse Scanned Products', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
