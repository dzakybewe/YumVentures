import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yum_ventures/provider/list_provider.dart';
import 'package:yum_ventures/ui/search_page.dart';
import 'package:yum_ventures/widgets/custom_restaurant_tile.dart';
import 'package:yum_ventures/widgets/support_widgets.dart';
import '../utils/result_state.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListProvider(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Recommended Restaurant'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, SearchPage.routeName);
                },
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                iconSize: 28,
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Consumer<ListProvider>(
              builder: (context, value, child) {
                if (value.state == ResultState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (value.state == ResultState.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: value.listResult.restaurants.length,
                    itemBuilder: (context, index) {
                      var restaurant = value.listResult.restaurants[index];
                      return CustomRestaurantTile(
                        context: context,
                        currentRestaurant: restaurant,
                        index: index,
                      );
                    },
                  );
                } else if (value.state == ResultState.error) {
                  return errorStateMessage();
                } else {
                  return const Center(
                    child: Text('Something Went Wrong'),
                  );
                }
              },
            ),
          )),
    );
  }
}
