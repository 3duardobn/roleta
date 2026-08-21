import 'package:flutter/material.dart';

import 'settings_repository.dart';

/// Estado observável das preferências do app (tema e idioma).
///
/// Persiste cada mudança via [SettingsRepository] e notifica os ouvintes,
/// eliminando a necessidade de repassar valores e callbacks tela a tela.
class AppPreferences extends ChangeNotifier {
  AppPreferences(this._settings);

  final SettingsRepository _settings;

  ThemeMode themeMode = ThemeMode.system;

  /// `null` significa seguir o idioma do sistema.
  Locale? locale;

  /// Carrega as preferências salvas. Falhas de leitura mantêm os padrões.
  Future<void> carregar() async {
    try {
      final tema = await _settings.carregarTema();
      final idioma = await _settings.carregarIdioma();
      themeMode = tema;
      locale = idioma;
      notifyListeners();
    } catch (_) {
      // Mantém os valores padrão.
    }
  }

  Future<void> setThemeMode(ThemeMode modo) async {
    if (themeMode == modo) return;
    themeMode = modo;
    notifyListeners();
    await _settings.salvarTema(modo);
  }

  Future<void> setLocale(Locale? idioma) async {
    if (locale == idioma) return;
    locale = idioma;
    notifyListeners();
    await _settings.salvarIdioma(idioma);
  }
}
