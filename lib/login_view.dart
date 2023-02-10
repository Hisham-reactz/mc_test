import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testwizard/weather_view.dart';

// Presentation layer
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final ImagePicker _picker = ImagePicker();
  File? _imager;

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];
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
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        final XFile? pickedFile = await _picker.pickImage(
                          source: ImageSource.camera,
                          maxWidth: 300,
                          maxHeight: 300,
                          imageQuality: 75,
                        );

                        _imager = File.fromUri(
                          Uri.parse(pickedFile!.path),
                        );
                        setState(() {});
                      } catch (e) {
                        rethrow;
                      }
                    },
                    child: SizedBox(
                      height: kIsWeb
                          ? MediaQuery.of(context).size.height / 8
                          : MediaQuery.of(context).size.height / 3,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            _imager == null ? null : FileImage(_imager!),
                        child: _imager == null
                            ? const Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 75,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    child: WeatherList(
                      useCase: GetWeatherData(
                        apiKey: 'FsVI66NjuLeyekD4N4OStYOq7Is8uyMD',
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        });
  }
}
