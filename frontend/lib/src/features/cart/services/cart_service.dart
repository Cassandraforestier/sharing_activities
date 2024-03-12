import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/cart_model_page.dart';

class CartService {
  String? url = dotenv.env['BACKEND_URL'];

  Future<Cart> getCart(String userId) async {
    final response = await http.get(Uri.parse('$url/api/cart/$userId'));

    final jsonData = json.decode(response.body);
    if (response.statusCode / 100 == 4 || response.statusCode / 100 == 5) {
      throw Exception('Unable to fetch cart: ${response.statusCode}');
    }
    return Cart(
      id: jsonData['_id'],
      activities: (jsonData['activityList'] as List)
          .map((activity) => Activity(
                id: activity['_id'],
                title: activity['title'],
                location: activity['location'],
                price: activity['price'].toDouble(),
                imageUrl: activity['imageUrl'],
              ))
          .toList(),
      totalPrice: jsonData['totalPrice'].toDouble(),
    );
  }

  Future<void> removeActivityFromCart(String cartId, String activityId) async {
    final response = await http
        .delete(Uri.parse('$url/api/cart/$cartId/activity/$activityId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to remove activity from cart');
    }
  }
}
