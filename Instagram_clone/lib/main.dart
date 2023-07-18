import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBPF-8Yr0X1I-5lvZ2r0QrAsdRgP57Dew4",
        appId: "1:27027134015:web:291a05d9fa0a02e27e8a8a",
        messagingSenderId: "27027134015",
        projectId: "instagram-clone-e254f",
        storageBucket: "instagram-clone-e254f.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const App());
}
