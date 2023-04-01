// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAO2Pq3kcBBCZ-vRvPBOcdDMeZ71hR9Lik',
    appId: '1:465016740072:web:549c7a5eee9f8a8f44115d',
    messagingSenderId: '465016740072',
    projectId: 'app-crypto-32249',
    authDomain: 'app-crypto-32249.firebaseapp.com',
    storageBucket: 'app-crypto-32249.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8p18HH6xyIWBui-xtdpNPmdTkksZghoA',
    appId: '1:465016740072:android:b11773ece0d1f7c944115d',
    messagingSenderId: '465016740072',
    projectId: 'app-crypto-32249',
    storageBucket: 'app-crypto-32249.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-yGq5HT5FKj3E_idDdjFLG7F4H8azqQE',
    appId: '1:465016740072:ios:6be96306eb4b5bf544115d',
    messagingSenderId: '465016740072',
    projectId: 'app-crypto-32249',
    storageBucket: 'app-crypto-32249.appspot.com',
    iosClientId: '465016740072-0t1a2c9359nv41l47okrm2rft0fcvebe.apps.googleusercontent.com',
    iosBundleId: 'com.example.crypto',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-yGq5HT5FKj3E_idDdjFLG7F4H8azqQE',
    appId: '1:465016740072:ios:0781e0a19726dbd144115d',
    messagingSenderId: '465016740072',
    projectId: 'app-crypto-32249',
    storageBucket: 'app-crypto-32249.appspot.com',
    iosClientId: '465016740072-qthr99va18eqpkc2l8j3hue5u311hcfs.apps.googleusercontent.com',
    iosBundleId: 'com.example.crypto.RunnerTests',
  );
}
