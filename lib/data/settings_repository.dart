import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const _themeKey = 'tema';

  Future<ThemeMode> carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themeKey) ?? 0;
    final clamped = index.clamp(0, ThemeMode.values.length - 1);
    return ThemeMode.values[clamped];
  }

  Future<void> salvarTema(ThemeMode tema) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, tema.index);
  }
}
