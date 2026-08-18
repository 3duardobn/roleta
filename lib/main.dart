import 'package:flutter/material.dart';

import 'data/caixa_repository.dart';
import 'data/settings_repository.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RoletaApp(
    repository: CaixaRepository(),
    settings: SettingsRepository(),
  ));
}

class RoletaApp extends StatefulWidget {
  const RoletaApp({
    super.key,
    required this.repository,
    required this.settings,
  });

  final CaixaRepository repository;
  final SettingsRepository settings;

  @override
  State<RoletaApp> createState() => _RoletaAppState();
}

class _RoletaAppState extends State<RoletaApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _carregarTema();
  }

  Future<void> _carregarTema() async {
    final tema = await widget.settings.carregarTema();
    if (mounted) setState(() => _themeMode = tema);
  }

  Future<void> _mudarTema(ThemeMode tema) async {
    setState(() => _themeMode = tema);
    await widget.settings.salvarTema(tema);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roleta',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: _themeMode,
      home: HomeScreen(
        repository: widget.repository,
        themeMode: _themeMode,
        onThemeChanged: _mudarTema,
      ),
    );
  }
}
