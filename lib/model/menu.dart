import 'dart:convert';
import 'package:flutter/material.dart';
import 'drink.dart';
import 'food.dart';

class Menus {
  List<Food> foods;
  List<Drink> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromRawJson(String str) => Menus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
    foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
    drinks: List<Drink>.from(json["drinks"].map((x) => Drink.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
    "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
  };
}
Future<Menus> fetchMenusData(BuildContext context, String restaurantId) async {
  String jsonString = await DefaultAssetBundle.of(context).loadString('assets/local_restaurant.json');
  Map<String, dynamic> jsonData = json.decode(jsonString);
  var restaurantData = jsonData['restaurants'].firstWhere(
        (restaurant) => restaurant['id'] == restaurantId,
    orElse: () => null,
  );
  return Menus.fromJson(restaurantData['menus']);
}