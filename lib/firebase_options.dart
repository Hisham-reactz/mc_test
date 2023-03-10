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
    apiKey: 'AIzaSyCJkhkGji9X0Y4-OSUoSdiKSRRpivrI1Kg',
    appId: '1:547269833536:web:32829c413098665c11c0a5',
    messagingSenderId: '547269833536',
    projectId: 'testwizard-98084',
    authDomain: 'testwizard-98084.firebaseapp.com',
    storageBucket: 'testwizard-98084.appspot.com',
    measurementId: 'G-FDDLQ66CPW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8Keg9oilTqGjEp_a6RLFTvJY3he3-7RU',
    appId: '1:547269833536:android:ed17df17ae72e65911c0a5',
    messagingSenderId: '547269833536',
    projectId: 'testwizard-98084',
    storageBucket: 'testwizard-98084.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBBMx4jU14Kr4ckZlkdvpUx3qoNZE8jEOA',
    appId: '1:547269833536:ios:950d01f02fefc27e11c0a5',
    messagingSenderId: '547269833536',
    projectId: 'testwizard-98084',
    storageBucket: 'testwizard-98084.appspot.com',
    iosClientId: '547269833536-9j5uc009k28fnirboqlenq477cladma8.apps.googleusercontent.com',
    iosBundleId: 'com.mobohybrid.testwizard',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBBMx4jU14Kr4ckZlkdvpUx3qoNZE8jEOA',
    appId: '1:547269833536:ios:950d01f02fefc27e11c0a5',
    messagingSenderId: '547269833536',
    projectId: 'testwizard-98084',
    storageBucket: 'testwizard-98084.appspot.com',
    iosClientId: '547269833536-9j5uc009k28fnirboqlenq477cladma8.apps.googleusercontent.com',
    iosBundleId: 'com.mobohybrid.testwizard',
  );
}
