import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yum_ventures/common/navigation.dart';
import 'package:yum_ventures/data/db/database_helper.dart';
import 'package:yum_ventures/data/model/list_result.dart';
import 'package:yum_ventures/provider/database_provider.dart';
import 'package:yum_ventures/provider/preferences_provider.dart';
import 'package:yum_ventures/provider/scheduling_provider.dart';
import 'package:yum_ventures/ui/base_page.dart';
import 'package:yum_ventures/ui/detail_page.dart';
import 'package:yum_ventures/ui/favorite_page.dart';
import 'package:yum_ventures/ui/home_page.dart';
import 'package:yum_ventures/ui/search_page.dart';
import 'package:yum_ventures/ui/settings_page.dart';
import 'package:yum_ventures/utils/preferences_helper.dart';

void main() {
  test('Parse JSON Test', () {
    const firstName = 'Resto Payakumbuah';
    const firstDesc = 'Resto terenak sedunia';
    const firstPictureId = 'abc123';
    const firstCity = 'Jakarta';
    const firstRating = 4.8;

    const secondName = 'McDonal Bebek';
    const secondDesc = 'Resto Junkfood';
    const secondPictureId = 'abc1333';
    const secondCity = 'Tangerang';
    const secondRating = 4.0;

    const jsonData = '''
      {
        "error": false,
        "message": "Success",
        "count": 2,
        "restaurants": [
          {
            "id": "1",
            "name": "$firstName",
            "description": "$firstDesc",
            "pictureId": "$firstPictureId",
            "city": "$firstCity",
            "rating": $firstRating
          },
          {
            "id": "2",
            "name": "$secondName",
            "description": "$secondDesc",
            "pictureId": "$secondPictureId",
            "city": "$secondCity",
            "rating": $secondRating
          }
        ]
      }
    ''';

    final ListResult result = parseListResultJsonData(jsonData);

    expect(result.error, false);
    expect(result.message, 'Success');
    expect(result.count, 2);
    expect(result.restaurants.length, 2);

    final Restaurant restaurant = result.restaurants[0];
    expect(restaurant.id, '1');
    expect(restaurant.name, firstName);
    expect(restaurant.description, firstDesc);
    expect(restaurant.pictureId, firstPictureId);
    expect(restaurant.city, firstCity);
    expect(restaurant.rating, firstRating);
  });


  Widget createHomeScreen() => MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
                sharedPreferences: SharedPreferences.getInstance()
            )
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
      ),
      ChangeNotifierProvider<SchedulingProvider>(
        create: (_) => SchedulingProvider(),
        child: const SettingsPage(),
      ),
    ],
    child: Consumer<PreferencesProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Restaurant App',
          theme: value.themeData,
          navigatorKey: navigatorKey,
          initialRoute: BasePage.routeName,
          routes: {
            BasePage.routeName : (context) => const BasePage(),
            HomePage.routeName : (context) => const HomePage(),
            DetailPage.routeName : (context) => DetailPage(
              id: ModalRoute.of(context)?.settings.arguments as String,
            ),
            SearchPage.routeName : (context) => const SearchPage(),
            FavoritePage.routeName : (context) => const FavoritePage(),
            SettingsPage.routeName : (context) => const SettingsPage(),
          },
        );
      },
    ),
  );

  group('Widget Test', () {
    testWidgets('Testing if Search Button can be clicked', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
    testWidgets('Testing if Resto Card can be clicked', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });
}

ListResult parseListResultJsonData(String jsonData) {
  Map<String, dynamic> jsonMap = json.decode(jsonData);

  return ListResult.fromJson(jsonMap);
}