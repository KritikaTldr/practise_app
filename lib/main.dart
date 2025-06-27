import 'package:flutter/material.dart';
import 'package:practise_app/screens/login_screen.dart';
import 'package:practise_app/screens/product_screen.dart';
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
      initialRoute: '/all-products', 
      routes: {
        '/all-products': (context) => const HomeScreen(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/verify') {
          final args = settings.arguments as Map<String, dynamic>;
          final email = args['email'] as String;
          return MaterialPageRoute(
            builder: (context) => VerifyScreen(email: email),
          );
        }

        // Handle /all-products/:id
        final uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments[0] == 'all-products') {
          final id = int.tryParse(uri.pathSegments[1]);
          if (id != null) {
            return MaterialPageRoute(
              builder: (context) => ProductScreen(productId: id),
              settings: settings,
            );
          }
        }

        // Redirect '/' to '/all-products'
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => const HomeScreen(),
            settings: const RouteSettings(name: '/all-products'),
          );
        }
        return null;
      },
    );
  }
}
