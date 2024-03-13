import 'package:flutter/material.dart';
import 'package:sharing_ativities/src/common_widgets/bottom_nav_bar.dart';
import '../models/cart_model_page.dart';
import '../services/cart_service.dart';

class CartPage extends StatefulWidget {
  final String userId;

  CartPage({required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  late Cart _cart;

  @override
  void initState() {
    super.initState();
    _cart = Cart(id: '', activities: [], totalPrice: 0);
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final cart = await _cartService.getCart(widget.userId);
      setState(() {
        _cart = cart;
      });
    } catch (e) {
      print("Error loading cart: $e");
    }
  }

  Future<void> _removeActivity(String activityId) async {
    try {
      await _cartService.removeActivityFromCart(_cart.id, activityId);
      _loadCart();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Activité supprimée du panier'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange[700],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression de l\'activité'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
        foregroundColor: Colors.white,
      ),
      body: _buildCartList(),
      bottomNavigationBar: BottomNavBarManager.build(context, 1),
    );
  }

  Widget _buildCartList() {
    return Column(
      children: [
        Expanded(
          child: _cart.activities.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 100,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        'Votre panier est vide',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _cart.activities.length,
                  itemBuilder: (context, index) {
                    final activity = _cart.activities[index];

                    return Card(
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      child: ListTile(
                        leading: Image.network(
                          activity.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(activity.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lieu: ${activity.location}'),
                            Text('Prix: ${activity.price}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          onPressed: () => _removeActivity(activity.id),
                        ),
                      ),
                    );
                  },
                ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.all(16.0),
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Total: ${_cart.totalPrice} €',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
