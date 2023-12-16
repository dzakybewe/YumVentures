import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yum_ventures/model/restaurant_element.dart';

class Restaurant {
  List<RestaurantElement> restaurants;

  Restaurant({
    required this.restaurants,
  });

  factory Restaurant.fromRawJson(String str) => Restaurant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    restaurants: List<RestaurantElement>.from(json["restaurants"].map((x) => RestaurantElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };
}

Future<Restaurant> fetchRestaurantData(BuildContext context) async {
  String jsonString = await DefaultAssetBundle.of(context).loadString('assets/local_restaurant.json');
  Map<String, dynamic> jsonData = json.decode(jsonString);
  return Restaurant.fromJson(jsonData);
}
