import 'package:flutter/material.dart';
import 'package:yum_ventures/model/restaurant.dart';
import 'package:yum_ventures/model/restaurant_element.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Restaurant'),
      ),
      body: FutureBuilder<Restaurant>(
        future: fetchRestaurantData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            return _buildRestaurantList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildRestaurantList(Restaurant restaurant) {
    return ListView.builder(
      itemCount: restaurant.restaurants.length,
      itemBuilder: (context, index) {
        final currentRestaurant = restaurant.restaurants[index];
        return _customRestaurantList(currentRestaurant, index, context);
      },
    );
  }

  Widget _customRestaurantList(RestaurantElement currentRestaurant, int index, BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, DetailPage.routeName, arguments: currentRestaurant);
      },
      child: Container(
        height: 290,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 66,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                  child: Hero(
                    tag: currentRestaurant.pictureId,
                    child: Image.network(currentRestaurant.pictureId, fit: BoxFit.cover,),
                  ),
                ),
              ),
              Expanded(
                flex: 33,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 50,
                        child: Text(
                          currentRestaurant.name,
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis
                          )
                        ),
                      ),
                      Expanded(
                        flex: 50,
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 22,
                            ),
                            Text(
                              currentRestaurant.city,
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                                overflow: TextOverflow.ellipsis,
                              )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
