import "package:firebase_core/firebase_core.dart";
import 'package:foodbridge/auth_service/models/filter_provider.dart';
import 'package:foodbridge/pages/auth/auth_page.dart';
import 'package:foodbridge/pages/home/home_page.dart';
import 'package:foodbridge/pages/home/profile_page.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => FilterModel())],
      child: MaterialApp(
        theme: _buildTheme(Brightness.light),
        title: 'Flutter',
        home: const AuthPage(),
      ),
    );
  }
}
