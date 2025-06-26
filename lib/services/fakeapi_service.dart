import 'package:dio/dio.dart';

class FakeApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://fakestoreapi.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  // GET all products
  static Future<Response> getAllProducts() {
    return _dio.get('/products');
  }

  // GET single product by ID
  static Future<Response> getProductById(int id) {
    return _dio.get('/products/$id');
  }

  // GET products by category
  static Future<Response> getProductsByCategory(String category) {
    return _dio.get('/products/category/$category');
  }

  // GET all categories
  static Future<Response> getCategories() {
    return _dio.get('/products/categories');
  }
}
