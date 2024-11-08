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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAonH20rjmH-N41UuSPDPZsnaaXfNIKIAA',
    appId: '1:1069790534107:web:db04c7b156d8a0314beffe',
    messagingSenderId: '1069790534107',
    projectId: 'expense-manager-a574c',
    authDomain: 'expense-manager-a574c.firebaseapp.com',
    storageBucket: 'expense-manager-a574c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAt1vUO9XVQLwin1o0P42xFmgLcrguPwU',
    appId: '1:1069790534107:android:37a82748f7adcccc4beffe',
    messagingSenderId: '1069790534107',
    projectId: 'expense-manager-a574c',
    storageBucket: 'expense-manager-a574c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBce_Xb4hu37VXAwdVntcinHaS2lakPmMM',
    appId: '1:1069790534107:ios:7d41f8f899ed00a14beffe',
    messagingSenderId: '1069790534107',
    projectId: 'expense-manager-a574c',
    storageBucket: 'expense-manager-a574c.appspot.com',
    iosBundleId: 'com.example.expenseManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBce_Xb4hu37VXAwdVntcinHaS2lakPmMM',
    appId: '1:1069790534107:ios:7d41f8f899ed00a14beffe',
    messagingSenderId: '1069790534107',
    projectId: 'expense-manager-a574c',
    storageBucket: 'expense-manager-a574c.appspot.com',
    iosBundleId: 'com.example.expenseManager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAonH20rjmH-N41UuSPDPZsnaaXfNIKIAA',
    appId: '1:1069790534107:web:e0d1bb907bc5dcea4beffe',
    messagingSenderId: '1069790534107',
    projectId: 'expense-manager-a574c',
    authDomain: 'expense-manager-a574c.firebaseapp.com',
    storageBucket: 'expense-manager-a574c.appspot.com',
  );
}