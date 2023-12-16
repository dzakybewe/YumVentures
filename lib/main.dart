import 'package:flutter/material.dart';
import 'package:yum_ventures/common/styles.dart';
import 'package:yum_ventures/model/restaurant_element.dart';
import 'package:yum_ventures/ui/detail_page.dart';
import 'package:yum_ventures/ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          tertiary: grayColor,
          background: primaryColor
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: primaryColor,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
            overflow: TextOverflow.ellipsis
          ),
          iconTheme: IconThemeData(
            color: textColor,
            size: 26,
          )
        ),
        useMaterial3: true,
        textTheme: textTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            foregroundColor: primaryColor,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0))
            )
          )
        )
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        DetailPage.routeName: (context) => DetailPage(
          currentRestaurant: ModalRoute.of(context)!.settings.arguments as RestaurantElement,
        ),
      },
    );
  }
}
