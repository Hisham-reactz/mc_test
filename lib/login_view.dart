import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:image_picker/image_picker.dart';

import './weather_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];
    final ImagePicker _picker = ImagePicker();
    File? imager;

    return MaterialApp(
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/profile',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/profile');
              }),
            ],
          );
        },
        '/profile': (context) {
          return Stack(
            children: [
              ProfileScreen(
                avatarSize: 100,
                providers: providers,
                actions: [
                  SignedOutAction((context) {
                    Navigator.pushReplacementNamed(context, '/sign-in');
                  }),
                ],
              ),
              Align(
                alignment: const Alignment(0, -0.75),
                child: GestureDetector(
                  onTap: () async {
                    try {
                      final XFile? pickedFile = await _picker.pickImage(
                        source: ImageSource.camera,
                        maxWidth: 300,
                        maxHeight: 300,
                        imageQuality: 75,
                      );

                      imager = File.fromUri(
                        Uri.parse(pickedFile!.path),
                      );
                      setState(() {
                        imager;
                      });
                    } catch (e) {
                      rethrow;
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: imager == null ? null : FileImage(imager!),
                    child: imager == null
                        ? const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 75,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      WeatherList(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      },
    );
  }
}
