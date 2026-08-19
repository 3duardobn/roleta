import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const _themeKey = 'tema';
  static const _languageKey = 'idioma';
  static const _systemDefault = 'system';

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

  /// Retorna `null` quando o idioma segue o padrão do sistema.
  Future<Locale?> carregarIdioma() async {
    final prefs = await SharedPreferences.getInstance();
    final codigo = prefs.getString(_languageKey);
    if (codigo == null || codigo == _systemDefault) return null;
    return Locale(codigo);
  }

  Future<void> salvarIdioma(Locale? idioma) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, idioma?.languageCode ?? _systemDefault);
  }
}
