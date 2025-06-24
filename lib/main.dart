import 'package:flutter/material.dart';
import 'package:practise_app/screens/login_screen.dart';
import 'package:practise_app/screens/signup_screen.dart';
import 'package:practise_app/screens/verify_screen.dart';
import 'package:practise_app/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/signup': (context) => const SignupScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/verify') {
            final args = settings.arguments as Map<String, dynamic>;
            final email = args['email'] as String;
            return MaterialPageRoute(
              builder: (context) => VerifyScreen(email: email),
            );
          }
          return null;
        },
      );

  }
}
