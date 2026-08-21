import 'package:flutter/material.dart';
import 'package:roleta/l10n/app_localizations.dart';

import 'data/app_preferences.dart';
import 'data/caixa_repository.dart';
import 'data/settings_repository.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RoletaApp(
    repository: CaixaRepository(),
    settings: AppPreferences(SettingsRepository()),
  ));
}

class RoletaApp extends StatefulWidget {
  const RoletaApp({
    super.key,
    required this.repository,
    required this.settings,
  });

  final CaixaRepository repository;
  final AppPreferences settings;

  @override
  State<RoletaApp> createState() => _RoletaAppState();
}

class _RoletaAppState extends State<RoletaApp> {
  @override
  void initState() {
    super.initState();
    widget.settings.carregar();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settings,
      builder: (context, _) => MaterialApp(
        title: 'Roleta',
        debugShowCheckedModeBanner: false,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        themeMode: widget.settings.themeMode,
        locale: widget.settings.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: HomeScreen(
          repository: widget.repository,
          settings: widget.settings,
        ),
      ),
    );
  }
}
