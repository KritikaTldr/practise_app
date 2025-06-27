import 'package:flutter/material.dart';
import 'package:practise_app/services/fakeapi_service.dart';
import 'package:practise_app/widgets/nav_bar.dart';

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
    final isWide = screenWidth > 900;
    final horizontalPadding = isWide ? screenWidth * 0.06 : 16.0;

    if (_loading) {
      return const Scaffold(
        appBar: NavBar(),
        body: Center(child: CircularProgressIndicator()),
        backgroundColor: Colors.white,
      );
    }

    if (_product == null) {
      return const Scaffold(
        appBar: NavBar(),
        body: Center(child: Text("Product not found")),
        backgroundColor: Colors.white,
      );
    }

    return Scaffold(
      appBar: const NavBar(),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isWide
                            ? _buildWideLayout(screenWidth)
                            : _buildNarrowLayout(screenWidth),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWideLayout(double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        Container(
          width: screenWidth * 0.35 > 400 ? 400 : screenWidth * 0.35,
          height: screenWidth * 0.4 > 500 ? 500 : screenWidth * 0.4,
          decoration: _imageBoxDecoration(),
          clipBehavior: Clip.hardEdge,
          child: Image.network(
            _product!['image'],
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 32),
        Expanded(child: _buildProductDetails()),
      ],
    );
  }

  Widget _buildNarrowLayout(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: screenWidth * 0.85,
          height: screenWidth * 0.85,
          margin: const EdgeInsets.only(bottom: 24),
          decoration: _imageBoxDecoration(),
          clipBehavior: Clip.hardEdge,
          child: Image.network(
            _product!['image'],
            fit: BoxFit.contain,
          ),
        ),
        _buildProductDetails(),
      ],
    );
  }

  BoxDecoration _imageBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey.shade400, width: 1.2),
      borderRadius: BorderRadius.circular(10),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _product!['title'],
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          _product!['description'],
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        Text(
          "\$${_product!['price']}",
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildQuantitySelector(),
        const SizedBox(height: 12),
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
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        MouseRegion(
          cursor: _quantity > 1 ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
          child: IconButton(
            icon: const Icon(Icons.remove, color: Colors.white),
            style: _buttonStyle(_quantity > 1),
            onPressed: _quantity > 1
                ? () => setState(() => _quantity--)
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
            style: _buttonStyle(_quantity < 7),
            onPressed: _quantity < 7
                ? () => setState(() => _quantity++)
                : null,
          ),
        ),
      ],
    );
  }

  ButtonStyle _buttonStyle(bool enabled) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(enabled ? Colors.orange : Colors.grey),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {},
          child: const Text("Add to Cart", style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {},
          child: const Text("Buy Now", style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    );
  }
}
 