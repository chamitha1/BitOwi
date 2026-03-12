import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    return android;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBNYOJAGmFCSJj_Wmtcl72-nGy-_8i0iyM",
    appId: "1:817994993109:web:e07494270cc3bb2255c15c",
    messagingSenderId: "817994993109",
    projectId: "bitowi-analytics",
    authDomain: "bitowi-analytics.firebaseapp.com",
    storageBucket: "bitowi-analytics.appspot.com",
    measurementId: "G-X1MG7LLNDS",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAit8I2rksltk_CEkn7bLQ3THblA-QQsBM",
    appId: "1:817994993109:android:df32b79f0d98236755c15c",
    messagingSenderId: "817994993109",
    projectId: "bitowi-analytics",
    storageBucket: "bitowi-analytics.appspot.com",
  );
}