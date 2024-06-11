import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_shop/models/m_products.dart';

/// Classe provider du produit
class PProducts with ChangeNotifier {
  List<MProducts> _allProducts = [];
  List<MProducts> _filteredProducts = [];
  final List<Map<String, dynamic>> _cartItems = [];
  String _searchQuery = '';
  double minPrice = 0;
  double maxPrice = 1000;
  RangeValues _currentRangeValues = const RangeValues(0, 1000);

  /// Afficher tous les produits
  Future<void> fetchAllProducts() async {
    try {
      final response = await http.get(
        Uri.https('https://dummyjson.com/products'),
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isNotEmpty) {
          final List<dynamic> parsedProducts = json.decode(responseBody)['products'];
          _allProducts = parsedProducts.map((json) => MProducts.fromJson(json)).toList();
          _calculatePriceRange();
          _applyFilter();
          notifyListeners();
        } else {
          throw Exception('Response body is null or empty');
        }
      } else {
        throw Exception('Failed to load products: ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }

  List<MProducts> get allProducts => _allProducts;

  List<MProducts> get filteredProducts => _filteredProducts;

  List<Map<String, dynamic>> get cartItems => _cartItems;

  String get searchQuery => _searchQuery;

  RangeValues get currentRangeValues => _currentRangeValues;

  void filterProducts(String query, RangeValues rangeValues) {
    _searchQuery = query;
    _currentRangeValues = rangeValues;
    _applyFilter();
    notifyListeners();
  }

  void _calculatePriceRange() {
    if (_allProducts.isNotEmpty) {
      double min = _allProducts[0].price;
      double max = _allProducts[0].price;
      for (var product in _allProducts) {
        if (product.price < min) {
          min = product.price;
        }
        if (product.price > max) {
          max = product.price;
        }
      }
      minPrice = min;
      maxPrice = max;
    }
  }

  void _applyFilter() {
    _filteredProducts = _allProducts.where((product) {
      final nameLower = product.title.toLowerCase();
      final price = product.price;
      final isNew = DateTime.now().difference(DateTime.parse(product.createdAt)).inDays <= 3;
      return nameLower.contains(_searchQuery.toLowerCase()) &&
          price >= _currentRangeValues.start &&
          price <= _currentRangeValues.end &&
          isNew;
    }).toList();
  }

  void addToCart(MProducts product) {
    _cartItems.add({
      'title': product.title,
      'price': product.price,
      'thumbnail': product.thumbnail,
    });
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }
}
