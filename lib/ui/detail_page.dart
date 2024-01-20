import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yum_ventures/data/model/detail_result.dart';
import 'package:yum_ventures/provider/detail_provider.dart';
import 'package:yum_ventures/widgets/custom_text_field.dart';
import '../data/result_state.dart';

class DetailPage extends StatefulWidget {
  final String id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DetailProvider(id: widget.id),
      child: Consumer<DetailProvider>(
        builder: (context, value, child) {
          final reviewProvider = Provider.of<DetailProvider>(context);
          if (value.state == ResultState.loading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary),
              ),
            );
          } else if (value.state == ResultState.hasData) {
            final currentRestaurant = value.detailResult.restaurant;
            return Scaffold(
              appBar: AppBar(
                title: Text(currentRestaurant.name),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                        child: Hero(
                            tag: currentRestaurant.pictureId,
                            child: Image.network(
                              'https://restaurant-api.dicoding.dev/images/medium/${currentRestaurant.pictureId}',
                              fit: BoxFit.cover,
                            )),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currentRestaurant.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                currentRestaurant.rating.toString(),
                                style: Theme.of(context).textTheme.labelLarge!,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 22,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            currentRestaurant.city,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
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
                      const SizedBox(
                        height: 16,
                      ),
                      _buildMenuList(currentRestaurant.menus, context),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _buildReviewDialog(
                                  context, reviewProvider, currentRestaurant);
                            },
                            child: const Text(
                              'Add Review',
                            ),
                          )
                        ],
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: currentRestaurant.customerReviews.length,
                          itemBuilder: (context, index) {
                            CustomerReview review =
                                currentRestaurant.customerReviews[index];
                            return ListTile(
                              leading: Text((index + 1).toString()),
                              title: Text(
                                review.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(review.review),
                              trailing: Text(review.date),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (value.state == ResultState.error) {
            return Scaffold(
              appBar: AppBar(),
              body: Text.rich(
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
              ),
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
    );
  }

  Future<dynamic> _buildReviewDialog(BuildContext context,
      DetailProvider reviewProvider, Restaurant currentRestaurant) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10)),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isEmpty ||
                      _reviewController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Please Fill in the blanks',
                      ),
                    ));
                  } else {
                    await reviewProvider.addReview(currentRestaurant.id,
                        _nameController.text, _reviewController.text);
                    if (context.mounted) {
                      _nameController.clear();
                      _reviewController.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Thanks for the review!'))
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10)),
                child: const Text('Submit'),
              )
            ],
          ),
        ],
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(controller: _nameController, hintText: 'name'),
              const SizedBox(height: 16),
              CustomTextField(
                  controller: _reviewController, hintText: 'review'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList(Menus menus, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: menus.foods
                .map((food) => Card(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            food.name,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
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
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: menus.drinks
                .map((food) => Card(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            food.name,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
