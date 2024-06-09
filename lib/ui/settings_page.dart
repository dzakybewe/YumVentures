import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yum_ventures/provider/preferences_provider.dart';
import 'package:yum_ventures/provider/scheduling_provider.dart';

import '../widgets/support_widgets.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings_page';

  const SettingsPage({super.key});

  static const textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              Material(
                child: ListTile(
                  title: const Text(
                    'Dark Theme',
                    style: textStyle,
                  ),
                  trailing: Switch.adaptive(
                    activeTrackColor: Theme.of(context).colorScheme.secondary,
                    value: provider.isDarkTheme,
                    onChanged: (value) {
                      provider.enableDarkTheme(value);
                    },
                  ),
                ),
              ),
              Material(
                child: ListTile(
                  title: const Text(
                    'Activate Scheduling',
                    style: textStyle,
                  ),
                  trailing: Consumer<SchedulingProvider>(
                    builder: (context, scheduled, _) {
                      return Switch.adaptive(
                        activeTrackColor:
                            Theme.of(context).colorScheme.secondary,
                        value: provider.isDailyNewsActive,
                        onChanged: (value) async {
                          if (Platform.isIOS) {
                            customDialog(context);
                          } else {
                            scheduled.scheduledNews(value);
                            provider.enableDailyNews(value);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
