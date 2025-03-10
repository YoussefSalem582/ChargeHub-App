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
    apiKey: 'AIzaSyDifeMzGPQirotbf5mMIg1HgTGuHSpgWq8',
    appId: '1:563160830766:web:e6a499a444fdb5d57720bf',
    messagingSenderId: '563160830766',
    projectId: 'chargehub-eb425',
    authDomain: 'chargehub-eb425.firebaseapp.com',
    storageBucket: 'chargehub-eb425.appspot.com',
    measurementId: 'G-SC5BTS786E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2Fe7c5-7warjjMJU1Omqlv5B2h1vDjSw',
    appId: '1:563160830766:android:f3cbf4e41eb7ebca7720bf',
    messagingSenderId: '563160830766',
    projectId: 'chargehub-eb425',
    storageBucket: 'chargehub-eb425.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHu3kxeXTiviXxpgwFgSQ_-yIoSBHxnrg',
    appId: '1:563160830766:ios:7c0193a2504ac63b7720bf',
    messagingSenderId: '563160830766',
    projectId: 'chargehub-eb425',
    storageBucket: 'chargehub-eb425.appspot.com',
    iosBundleId: 'com.example.chargehub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAHu3kxeXTiviXxpgwFgSQ_-yIoSBHxnrg',
    appId: '1:563160830766:ios:7c0193a2504ac63b7720bf',
    messagingSenderId: '563160830766',
    projectId: 'chargehub-eb425',
    storageBucket: 'chargehub-eb425.appspot.com',
    iosBundleId: 'com.example.chargehub',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDifeMzGPQirotbf5mMIg1HgTGuHSpgWq8',
    appId: '1:563160830766:web:2660286eecb90d1c7720bf',
    messagingSenderId: '563160830766',
    projectId: 'chargehub-eb425',
    authDomain: 'chargehub-eb425.firebaseapp.com',
    storageBucket: 'chargehub-eb425.appspot.com',
    measurementId: 'G-MY4W9S8BS9',
  );
}
