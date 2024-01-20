import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yum_ventures/common/styles.dart';
import 'package:yum_ventures/provider/list_provider.dart';
import 'package:yum_ventures/ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ListProvider>(
          create: (_) => ListProvider(),
        ),
      ],
      child: MaterialApp(
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
              elevation: 5,
              backgroundColor: secondaryColor,
              foregroundColor: primaryColor,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))
              )
            )
          )
        ),
        home: const HomePage(),
      ),
    );
  }
}
