import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yum_ventures/provider/list_provider.dart';
import 'package:yum_ventures/ui/search_page.dart';
import 'package:yum_ventures/widgets/custom_restaurant_tile.dart';
import '../data/result_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Restaurant'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage())),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Consumer<ListProvider>(
          builder: (context, value, child) {
            if (value.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (value.state == ResultState.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: value.listResult.restaurants.length,
                itemBuilder: (context, index){
                  var restaurant = value.listResult.restaurants[index];
                  return CustomRestaurantTile(
                    context: context,
                    currentRestaurant: restaurant,
                    index: index,
                  );
                },
              );
            } else if (value.state == ResultState.error) {
              return Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Please check your internet\n',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '${value.message}\n',
                    ),
                    const TextSpan(
                      text: 'If the problem still occur, kindly contact us',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              );
            } else {
              return const Center(
                child: Material(
                  child: Text(''),
                ),
              );
            }
          },
        ),
      )
    );
  }
}
