import 'package:flutter/material.dart';
import 'package:yum_ventures/model/menu.dart';
import 'package:yum_ventures/model/restaurant_element.dart';

class DetailPage extends StatelessWidget {
  static const routeName = '/detail_page';
  final RestaurantElement currentRestaurant;
  const DetailPage({super.key, required this.currentRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentRestaurant.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: Hero(
                  tag: currentRestaurant.pictureId,
                  child: Image.network(currentRestaurant.pictureId),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentRestaurant.name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 3,),
                      Text(
                        currentRestaurant.rating.toString(),
                        style: Theme.of(context).textTheme.labelLarge!,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 2,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 22,
                  ),
                  const SizedBox(width: 2,),
                  Text(
                    currentRestaurant.city,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                currentRestaurant.description,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 8,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16,),
              FutureBuilder<Menus>(
                future: fetchMenusData(context, currentRestaurant.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No menu data available');
                  } else {
                    return _buildMenuList(snapshot.data!, context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList(Menus menus, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foods:',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            childAspectRatio: 1.5,
            children: menus.foods.map((food) => Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    food.name,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
        const SizedBox(height: 12,),
        Text(
          'Drinks:',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            childAspectRatio: 1.5,
            children: menus.drinks.map((food) => Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    food.name,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}
