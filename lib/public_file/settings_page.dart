import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jomakase/public_file/theme_notifier.dart';
import 'package:jomakase/public_file/layout.dart'; // Layout import 추가

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '앱 설정', // Layout에 title 전달
      child: ListView(
        children: [
          Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) {
              return ListTile(
                title: const Text('다크 모드'),
                trailing: Icon(
                  themeNotifier.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onTap: () {
                  themeNotifier.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}