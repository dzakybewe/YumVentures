import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yum_ventures/widgets/custom_restaurant_tile.dart';

import '../provider/database_provider.dart';
import '../utils/result_state.dart';

class FavoritePage extends StatelessWidget {
  static const routeName = '/favorite_page';

  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorite Restaurant'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Consumer<DatabaseProvider>(
          builder: (context, provider, child) {
            if (provider.state == ResultState.hasData) {
              return ListView.builder(
                itemCount: provider.favorites.length,
                itemBuilder: (context, index) {
                  var restaurant = provider.favorites[index];
                  return CustomRestaurantTile(
                    currentRestaurant: restaurant,
                    context: context,
                    index: index,
                  );
                },
              );
            } else {
              return Center(
                child: Material(
                  child: Text(
                    provider.message,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
