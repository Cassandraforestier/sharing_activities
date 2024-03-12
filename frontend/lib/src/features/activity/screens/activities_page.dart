import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/common_widgets/bottom_nav_bar.dart';
import 'package:flutter_application_1/src/features/activity/controllers/activities_controller.dart';
import 'package:flutter_application_1/src/features/activity/screens/activity_detail_page.dart';
import 'package:flutter_application_1/src/features/cart/models/cart_model_page.dart';

class ActivitiesPage extends StatefulWidget {
  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchActivities('toutes');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchActivities(String selectedCategory) async {
    try {
      ActivitiesController activitiesController = ActivitiesController();

      List<Activity> fetchedActivities =
          await activitiesController.fetchActivities(selectedCategory);

      setState(() {
        activities = fetchedActivities;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching activities: $e");
    }
  }

  void onCategorySelected(String category) {
    fetchActivities(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activités'),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Toutes'),
            Tab(text: 'Sport'),
            Tab(text: 'Cuisine'),
            Tab(text: 'Art'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          onTap: (index) {
            String category;
            switch (index) {
              case 0:
                category = 'toutes';
              case 1:
                category = 'sport';
              case 2:
                category = 'cuisine';
              case 3:
                category = 'art';
              default:
                category = 'toutes';
            }
            onCategorySelected(category);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : activities.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Aucune activité trouvée',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    return _buildActivityItem(activities[index]);
                  },
                ),
      bottomNavigationBar: BottomNavBarManager.build(context, 0),
    );
  }

  Widget _buildActivityItem(Activity activity) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetailsPage(activityId: activity.id),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  activity.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Lieu: ${activity.location}'),
                    Text('Prix: ${activity.price} €'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
