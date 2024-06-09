import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yum_ventures/common/navigation.dart';
import 'package:yum_ventures/provider/database_provider.dart';
import 'package:yum_ventures/provider/preferences_provider.dart';
import 'package:yum_ventures/provider/scheduling_provider.dart';
import 'package:yum_ventures/ui/base_page.dart';
import 'package:yum_ventures/ui/detail_page.dart';
import 'package:yum_ventures/ui/favorite_page.dart';
import 'package:yum_ventures/ui/home_page.dart';
import 'package:yum_ventures/ui/search_page.dart';
import 'package:yum_ventures/ui/settings_page.dart';
import 'package:yum_ventures/utils/background_service.dart';
import 'package:yum_ventures/utils/notification_helper.dart';
import 'package:yum_ventures/utils/preferences_helper.dart';

import 'data/db/database_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
              preferencesHelper: PreferencesHelper(
                  sharedPreferences: SharedPreferences.getInstance())),
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
              BasePage.routeName: (context) => const BasePage(),
              HomePage.routeName: (context) => const HomePage(),
              DetailPage.routeName: (context) => DetailPage(
                    id: ModalRoute.of(context)?.settings.arguments as String,
                  ),
              SearchPage.routeName: (context) => const SearchPage(),
              FavoritePage.routeName: (context) => const FavoritePage(),
              SettingsPage.routeName: (context) => const SettingsPage(),
            },
          );
        },
      ),
    );
  }
}
