import 'dart:convert';
import 'package:flutter_application_1/src/features/activity/screens/activities_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/cart/models/cart_model_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../common_widgets/bottom_nav_bar.dart';

class ActivityDetailsPage extends StatefulWidget {
  final String activityId;

  ActivityDetailsPage({
    required this.activityId,
  });

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  bool isLoading = true;
  late String detailTitle;
  late String detailLocation;
  late String detailPrice;
  late String detailImageUrl;
  late String detailCategory;
  late String detailMinPeople;
  String? url = dotenv.env['BACKEND_URL'];

  @override
  void initState() {
    super.initState();
    fetchActivityDetails(widget.activityId);
  }

  Future<void> fetchActivityDetails(String activityId) async {
    final response =
        await http.get(Uri.parse("$url/api/activities/$activityId"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> activityDetails = json.decode(response.body);
      detailTitle = activityDetails['title'];
      detailLocation = activityDetails['location'];
      detailPrice = activityDetails['price'].toString();
      detailImageUrl = activityDetails['imageUrl'];
      detailCategory = activityDetails['category'];
      detailMinPeople = activityDetails['minPeople'].toString();

      setState(() {
        isLoading = false;
      });
    } else {
      print(
          "Failed to fetch activity details. Status code: ${response.statusCode}");
    }
  }

  Future<Cart> _getCart(String userId) async {
    try {
      final response = await http.get(Uri.parse('$url/api/cart/$userId'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        Cart userCart = Cart(
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
        return userCart;
      } else {
        throw Exception('Failed to fetch cart: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching cart: $error');
    }
  }

  Future<bool> addActivityToCart(String activityId, String cartId) async {
    String cartIdFinal = cartId;
    final response = await http
        .post(Uri.parse("$url/api/cart/$cartIdFinal/activity/$activityId"));

    if (response.statusCode == 200 && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ActivitiesPage()),
      );
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail de l\'activité'),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  child: Image.network(
                    detailImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    detailTitle,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Prix : $detailPrice €',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$detailPrice €',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Lieu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        detailLocation,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Catégorie',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        detailCategory,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Nombre de personnes minimum',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        detailMinPeople,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
      bottomNavigationBar: BottomNavBarManager.build(context, 0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          Map<String, String?> userData = await getData();
          String? userId = userData['userId'];
          Cart? userCart;
          try {
            userCart = await _getCart(userId!);
          } catch (e) {
            print('Error fetching cart: $e');
          }
          if (userCart == null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Nous n\'avons pas pu trouver votre panier! Veuillez réessayer plus tard.'),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.redAccent,
              ),
            );
            return;
          }
          String cartId = userCart!.id;
          addActivityToCart(widget.activityId, cartId).then((bool success) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Votre activité a été ajoutée au panier! 😁'),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Vous avez déjà ajouté cette activité à votre panier! 😅'),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          }).catchError((onError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Echec de l\'ajout au panier! Veuillez réessayer plus tard.'),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.redAccent,
              ),
            );
          });
        },
        child: Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }
}
