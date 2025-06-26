import 'package:flutter/material.dart';
import 'package:practise_app/services/fakeapi_service.dart';

class ProductScreen extends StatefulWidget {
  final int productId;

  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Map<String, dynamic>? _product;
  bool _loading = true;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    try {
      final response = await FakeApiService.getProductById(widget.productId);
      setState(() {
        _product = response.data;
        _loading = false;
      });
    } catch (e) {
      print("Error fetching product: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive: use Column for small screens, Row for large screens
    final isWide = screenWidth > 900;

    final content = isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: screenWidth * 0.32 > 400 ? 400 : screenWidth * 0.9,
                height: screenWidth * 0.4 > 500 ? 500 : screenWidth * 0.6,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 1.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  _product!['image'],
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 32),
              // Product Details
              Expanded(
                child: _buildProductDetails(),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image
              Container(
                width: screenWidth * 0.8,
                height: screenWidth * 0.8,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 1.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  _product!['image'],
                  fit: BoxFit.contain,
                ),
              ),
              _buildProductDetails(),
            ],
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: const Color(0xFFFEF7FF),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _product == null
              ? const Center(child: Text("Product not found"))
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? screenWidth * 0.08 : 16,
                    vertical: isWide ? 40 : 16,
                  ),
                  child: content,
                ),
    );
  }

  // Helper widget for product details
  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _product!['title'],
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _product!['description'],
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Text(
            "\$${_product!['price']}",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              MouseRegion(
                cursor: _quantity > 1 ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
                child: IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      _quantity > 1 ? Colors.orange : Colors.grey,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  onPressed: _quantity > 1
                      ? () {
                          setState(() {
                            _quantity--;
                          });
                        }
                      : null,
                ),
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  "$_quantity",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              MouseRegion(
                cursor: _quantity < 7 ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      _quantity < 7 ? Colors.orange : Colors.grey,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  onPressed: _quantity < 7
                      ? () {
                          setState(() {
                            _quantity++;
                          });
                        }
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 22),
              const SizedBox(width: 4),
              Text(
                "${_product!['rating']['rate']} (${_product!['rating']['count']})",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Buy Now",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
