import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_page.dart';
import 'message_page.dart';
import 'creer_tenue.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Demo App",
      initialRoute: "/splash",
      routes: {
        "/splash": (context) => const SplashScreen(),
        "/home": (context) => const HomePage(),
        "/message": (context) => const MessagePage(),
          "/creer_tenue": (context) => const CreerTenuePage(), // 👈 nouvelle route

      },
    );
  }
}
