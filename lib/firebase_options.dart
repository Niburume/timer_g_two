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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyADEivr3TOQ_G7_hmUApUW3zck-9SrFbYI',
    appId: '1:739229502650:web:59b1db846cf1c1be1b0683',
    messagingSenderId: '739229502650',
    projectId: 'timerg-a31ec',
    authDomain: 'timerg-a31ec.firebaseapp.com',
    databaseURL: 'https://timerg-a31ec-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'timerg-a31ec.appspot.com',
    measurementId: 'G-C9VGV19M67',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9XGHReZ7QmYnS3rILkC9j4atVquJ5_QU',
    appId: '1:739229502650:android:80c7a06bf2e053cd1b0683',
    messagingSenderId: '739229502650',
    projectId: 'timerg-a31ec',
    databaseURL: 'https://timerg-a31ec-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'timerg-a31ec.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFTxGmT8odV_xBOxNf21s3mY_yVsz6Mhk',
    appId: '1:739229502650:ios:3e686aa1a3b266c21b0683',
    messagingSenderId: '739229502650',
    projectId: 'timerg-a31ec',
    databaseURL: 'https://timerg-a31ec-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'timerg-a31ec.appspot.com',
    iosClientId: '739229502650-1h1hamgvmh9s5vdmnjm12u9tohe7ivqe.apps.googleusercontent.com',
    iosBundleId: 'com.example.timerGTwo',
  );
}
