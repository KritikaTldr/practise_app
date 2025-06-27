import 'package:flutter/material.dart';
import 'package:practise_app/services/token_service.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NavBarState extends State<NavBar> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await TokenService.getToken();
    setState(() {
      _token = token;
    });
  }

  Future<void> _logout() async {
    await TokenService.clearToken();
    setState(() {
      _token = null;
    });
    // Optionally navigate to login or home
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/all-products');
        },
        child: const Text(
          'Practise App',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFEF7FF),
      elevation: 2,
      actions: [
        if (_token == null) ...[
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: const Text(
              "Signup",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ] else ...[
          // Cart Icon
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.deepOrange, size: 28),
              tooltip: 'Cart',
              onPressed: () {
                // TODO: Navigate to cart page or show cart dialog
              },
            ),
          ),
          TextButton(
            onPressed: _logout,
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
        const SizedBox(width: 16),
      ],
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }
}
