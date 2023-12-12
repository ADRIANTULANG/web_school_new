import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:web_school/app.dart';
import 'package:web_school/firebase_options.dart';
import 'url_strategy/non_web.dart'
    if (dart.library.html) 'url_strategy/web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureUrl();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCd7Jptmp-yQUGeYliCtyf33nnoq7B3INw",
          authDomain: "enrollment-8bef4.firebaseapp.com",
          databaseURL: "https://enrollment-8bef4-default-rtdb.firebaseio.com",
          projectId: "enrollment-8bef4",
          storageBucket: "enrollment-8bef4.appspot.com",
          messagingSenderId: "759159093073",
          appId: "1:759159093073:web:4b3ef60d86c3636099c570",
          measurementId: "G-LTWDS054WW"),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (Platform.isAndroid) PathProviderAndroid.registerWith();

    // await StudentDB().initNotifications();
  }

  runApp(MyApp());
}
