import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testwizard/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD8Keg9oilTqGjEp_a6RLFTvJY3he3-7RU",
      appId: "1:547269833536:web:32829c413098665c11c0a5",
      messagingSenderId: "547269833536",
      projectId: "testwizard-98084",
    ),
  );
  runApp(const LoginView());
}
