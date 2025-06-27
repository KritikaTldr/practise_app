// ignore_for_file: unused_import, unreachable_switch_default

import 'package:flutter/material.dart';
import 'package:practise_app/services/fakeapi_service.dart';
import 'package:practise_app/screens/product_screen.dart';
import 'package:practise_app/widgets/nav_bar.dart';
import 'package:practise_app/services/token_service.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _products = [];
  bool _loading = true;
  List<bool> _isHovered = [];
  List<bool> _isCartHovered = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await FakeApiService.getAllProducts();
      setState(() {
        _products = response.data;
        _isHovered = List.generate(response.data.length, (_) => false);
        _isCartHovered = List.generate(response.data.length, (_) => false);
        _loading = false;
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  void showToast(BuildContext context, String title, String description, ToastificationType type) {
    Icon icon;
    switch (type) {
      case ToastificationType.success:
        icon = const Icon(Icons.check_circle, color: Colors.white, size: 28);
        break;
      case ToastificationType.info:
        icon = const Icon(Icons.info, color: Colors.white, size: 28);
        break;
      case ToastificationType.warning:
        icon = const Icon(Icons.warning, color: Colors.white, size: 28);
        break;
      case ToastificationType.error:
        icon = const Icon(Icons.error, color: Colors.white, size: 28);
        break;
      default:
        icon = const Icon(Icons.notifications, color: Colors.white, size: 28);
    }

    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.fillColored,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        description,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      icon: icon,
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.always,
      dragToClose: true,
      pauseOnHover: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60.0, bottom: 50.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.8,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/all-products/${product['id']}');
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => _isHovered[index] = true),
                      onExit: (_) => setState(() => _isHovered[index] = false),
                      child: AnimatedScale(
                        scale: _isHovered[index] ? 1.03 : 1.0,
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeInOut,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 30.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          product['image'],
                                          width: double.infinity,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product['title'].length > 30
                                        ? '${product['title'].substring(0, 30)}...'
                                        : product['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0, right: 5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\$${product['price']}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        MouseRegion(
                                          onEnter: (_) => setState(() => _isCartHovered[index] = true),
                                          onExit: (_) => setState(() => _isCartHovered[index] = false),
                                          child: GestureDetector(
                                            onTap: () async {
                                              final token = await TokenService.getToken();
                                              if (token == null) {
                                                showToast(
                                                  context,
                                                  'Login Required',
                                                  'Please login or signup to add items to the cart.',
                                                  ToastificationType.info,
                                                );
                                              } else {
                                                showToast(
                                                  context,
                                                  'Added to Cart',
                                                  'An item was added to your cart!',
                                                  ToastificationType.success,
                                                );
                                              }
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 180),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: _isCartHovered[index]
                                                    ? [
                                                        BoxShadow(
                                                          color: Colors.deepOrange.withOpacity(0.4),
                                                          blurRadius: 12,
                                                          spreadRadius: 1,
                                                        ),
                                                      ]
                                                    : [],
                                              ),
                                              child: const Icon(
                                                Icons.shopping_cart_outlined,
                                                size: 28,
                                                color: Colors.deepOrange,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
