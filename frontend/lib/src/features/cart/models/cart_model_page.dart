class Cart {
  final String id;
  final List<Activity> activities;
  final double totalPrice;

  Cart({required this.id, required this.activities, required this.totalPrice});
}

class Activity {
  final String id;
  final String title;
  final String location;
  final double price;
  final String imageUrl;

  Activity(
      {required this.id,
      required this.title,
      required this.location,
      required this.price,
      required this.imageUrl});
}
