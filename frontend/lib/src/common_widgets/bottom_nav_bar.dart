import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/activity/screens/activities_page.dart';
import 'package:flutter_application_1/src/features/cart/screens/cart_page.dart';
import 'package:flutter_application_1/src/features/user/screens/user_informations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String?>> getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username');
  String? userId = prefs.getString('userId');
  return {'username': username, 'userId': userId};
}

class BottomNavBarManager {
  static void navigate(BuildContext context, int index) async {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ActivitiesPage()),
        );
      case 1:
        Map<String, String?> userData = await getData();
        String? userId = userData['userId'];

        if (userId != null && context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage(userId: userId)),
          );
        } else {
          print('Impossible de récupérer l\'identifiant de l\'utilisateur');
        }
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
    }
  }

  static Widget build(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Activités',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Panier',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      onTap: (index) => navigate(context, index),
    );
  }
}
