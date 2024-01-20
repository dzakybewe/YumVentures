import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage(id: currentRestaurant.id))
        );
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
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                    child: Hero(
                      tag: currentRestaurant.pictureId,
                      child: Image.network('https://restaurant-api.dicoding.dev/images/medium/${currentRestaurant.pictureId}', fit: BoxFit.cover,),
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