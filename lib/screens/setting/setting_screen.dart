import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/providers/app_theme_provider.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "App Theme",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Light Mode",
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Consumer<AppThemeProvider>(builder: (context, model, child) {
                    return Switch(
                      value: model.themeMode != ThemeMode.dark,
                      onChanged: (value) {
                        if (value) {
                          Provider.of<AppThemeProvider>(context, listen: false)
                              .changeTheme(ThemeMode.light);
                        } else {
                          Provider.of<AppThemeProvider>(context, listen: false)
                              .changeTheme(ThemeMode.dark);
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
