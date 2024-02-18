import "package:firebase_core/firebase_core.dart";
import 'package:foodbridge/pages/auth/auth_page.dart';
import 'package:foodbridge/pages/home/home_page.dart';
import 'package:foodbridge/pages/home/profile_page.dart';
import "firebase_options.dart";
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

const c1 = Color.fromRGBO(25, 37, 61, 1);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseFirestore.instance.settings =
  //     const Settings(persistenceEnabled: true);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildTheme(Brightness.light),
      title: 'Flutter',
      home: const AuthPage(),
      routes: {
        "/home/": (context) => const HomePage(),
        "/profile/": (context) => const ProfilePage()
      },
    );
  }
}
