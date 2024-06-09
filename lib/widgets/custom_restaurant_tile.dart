import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yum_ventures/provider/database_provider.dart';
import '../common/navigation.dart';
import '../data/model/list_result.dart';
import '../ui/detail_page.dart';

class CustomRestaurantTile extends StatelessWidget {
  const CustomRestaurantTile({
    super.key,
    required this.currentRestaurant,
    required this.index,
    required this.context,
  });

  final Restaurant currentRestaurant;
  final int index;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder(
          future: provider.isBookmarked(currentRestaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return GestureDetector(
              onTap: () {
                Navigation.intentWithData(
                    DetailPage.routeName, currentRestaurant.id);
              },
              child: Container(
                height: 290,
                padding: const EdgeInsets.only(bottom: 10.0),
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
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16.0)),
                            child: Hero(
                              tag: currentRestaurant.pictureId,
                              child: Image.network(
                                'https://restaurant-api.dicoding.dev/images/medium/${currentRestaurant.pictureId}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error_outline),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white));
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 33,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                    flex: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          currentRestaurant.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                        ),
                                        isBookmarked
                                            ? IconButton(
                                                icon:
                                                    const Icon(Icons.favorite),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                onPressed: () =>
                                                    provider.removeBookmark(
                                                        currentRestaurant.id),
                                              )
                                            : IconButton(
                                                icon: const Icon(
                                                    Icons.favorite_border),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                onPressed: () =>
                                                    provider.addBookmark(
                                                        currentRestaurant),
                                              ),
                                      ],
                                    )),
                                Expanded(
                                  flex: 50,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: 22,
                                      ),
                                      Text(
                                        currentRestaurant.city,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            );
          },
        );
      },
    );
  }
}
