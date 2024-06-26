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
    apiKey: 'AIzaSyCeNWf8mR4DBhoQ-9wEYCVchyn24JR_4so',
    appId: '1:895603888851:web:7315f0eb9733fa9f173a26',
    messagingSenderId: '895603888851',
    projectId: 'puddls',
    authDomain: 'puddls.firebaseapp.com',
    storageBucket: 'puddls.appspot.com',
    measurementId: 'G-VCDBDP3DZT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBe7V3oFeDwZ4aYOlX9crkcTyuPTERgK7c',
    appId: '1:895603888851:android:6ab8b33d5bedcda5173a26',
    messagingSenderId: '895603888851',
    projectId: 'puddls',
    storageBucket: 'puddls.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpLmyxVZzag5Rz04fkWj0liY5cavpk7wA',
    appId: '1:895603888851:ios:4bdb1b00ba377731173a26',
    messagingSenderId: '895603888851',
    projectId: 'puddls',
    storageBucket: 'puddls.appspot.com',
    iosBundleId: 'com.puddls.puddls',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCpLmyxVZzag5Rz04fkWj0liY5cavpk7wA',
    appId: '1:895603888851:ios:4bdb1b00ba377731173a26',
    messagingSenderId: '895603888851',
    projectId: 'puddls',
    storageBucket: 'puddls.appspot.com',
    iosBundleId: 'com.puddls.puddls',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCeNWf8mR4DBhoQ-9wEYCVchyn24JR_4so',
    appId: '1:895603888851:web:d7e45c9f99c83525173a26',
    messagingSenderId: '895603888851',
    projectId: 'puddls',
    authDomain: 'puddls.firebaseapp.com',
    storageBucket: 'puddls.appspot.com',
    measurementId: 'G-J792F9TVJ3',
  );
}
