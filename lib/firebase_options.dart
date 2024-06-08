// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBBAkEXmkSlj34IV532BoJxKmaXZaM53Yg',
    appId: '1:1058125658111:web:2c5e6df38e5f93eb5099ca',
    messagingSenderId: '1058125658111',
    projectId: 'labe-scanner-1302',
    authDomain: 'labe-scanner-1302.firebaseapp.com',
    storageBucket: 'labe-scanner-1302.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAfZn9bYpZkan4VZTTwHIuMs7INsGwBANY',
    appId: '1:1058125658111:android:07a398871a7a792a5099ca',
    messagingSenderId: '1058125658111',
    projectId: 'labe-scanner-1302',
    storageBucket: 'labe-scanner-1302.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCEeTFAdGEyQaOQuWwvn8zXilHMx4ciJjc',
    appId: '1:1058125658111:ios:0b1cb614aff8a2ee5099ca',
    messagingSenderId: '1058125658111',
    projectId: 'labe-scanner-1302',
    storageBucket: 'labe-scanner-1302.appspot.com',
    iosBundleId: 'com.example.labelScanner',
  );
}
