import 'dart:convert';
import 'package:sharing_ativities/src/features/cart/models/cart_model_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ActivitiesController {
  String? url = dotenv.env['BACKEND_URL'];

  Future<List<Activity>> fetchActivities(String selectedCategory) async {
    final response = await http.get(
      Uri.parse("$url/api/activities/category/$selectedCategory"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> activitiesData = json.decode(response.body);
      List<Activity> activities = [];

      for (var activityData in activitiesData) {
        activities.add(Activity(
          id: activityData['_id'],
          title: activityData['title'],
          imageUrl: activityData['imageUrl'],
          location: activityData['location'],
          price: double.parse(activityData['price'].toString()),
        ));
      }
      return activities;
    } else {
      throw Exception(
          "Failed to fetch activities. Status code: ${response.statusCode}");
    }
  }
}
