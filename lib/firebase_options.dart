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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlFBl9OC5R2nFT0nTZLbCZguqhhg0oku4',
    appId: '1:442731666407:android:04b80bc9236842c4acfb42',
    messagingSenderId: '442731666407',
    projectId: 'vetplus-app',
    storageBucket: 'vetplus-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1RzbZzprYOqAsjBVCxQPRhGR6AkERoPQ',
    appId: '1:442731666407:ios:b07d512b3dfd35a3acfb42',
    messagingSenderId: '442731666407',
    projectId: 'vetplus-app',
    storageBucket: 'vetplus-app.appspot.com',
    androidClientId: '442731666407-9opok297a59ghvrf730ophmb9ilqobu3.apps.googleusercontent.com',
    iosClientId: '442731666407-dcqi21hodnqnef4c5uvpd1uvk7bb3hkt.apps.googleusercontent.com',
    iosBundleId: 'com.example.vetplus',
  );
}
