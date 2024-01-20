import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yum_ventures/provider/search_provider.dart';

import '../data/model/list_result.dart';
import '../data/result_state.dart';
import '../widgets/custom_restaurant_tile.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search For Restaurant'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => SearchProvider(query: ''),
        child: Consumer<SearchProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      provider.fetchSearch(query);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary),
                      hintText: 'Search',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: _buildSearchResults(provider)
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchResults(SearchProvider provider) {
    switch (provider.state) {
      case ResultState.loading:
        return const CircularProgressIndicator();
      case ResultState.hasData:
        return _buildResultsList(provider.searchResult.restaurants);
      case ResultState.noData:
        return const Text('No results found.');
      case ResultState.error:
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
                text: '${provider.message}\n',
              ),
              const TextSpan(
                text: 'If the problem still occur, kindly contact us',
              ),
            ],
          ),
          textAlign: TextAlign.center,
        );
      default:
        return Container();
    }
  }

  Widget _buildResultsList(List<Restaurant> restaurants) {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        var currentRestaurant = restaurants[index];
        return CustomRestaurantTile(currentRestaurant: currentRestaurant, index: index, context: context);
      },
    );
  }
}
