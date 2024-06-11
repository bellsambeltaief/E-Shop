import 'dart:convert';
import 'package:http/http.dart' as http;

class MProducts {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final String createdAt;
  final double discountPercentage;

  MProducts({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.createdAt,
    required this.discountPercentage,
  });

 factory MProducts.fromJson(Map<String, dynamic> json) {
  return MProducts(
    id: json['id'],
    title: json['title'],
    price: json['price'].toDouble(),
    thumbnail: json['thumbnail'],
    createdAt: json['meta']['createdAt'], 
    discountPercentage: json['discountPercentage'] != null ? json['discountPercentage'].toDouble() : 0,
  );
}

  static Future<List<MProducts>> fetchAllProducts() async {
    try {
      final response = await http.get(
        Uri.https('dummyjson.com', 'products'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> parsedProducts = json.decode(response.body)['products'];
        return parsedProducts.map((json) => MProducts.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }
}
