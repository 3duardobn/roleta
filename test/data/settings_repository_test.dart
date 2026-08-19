import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roleta/data/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('idioma começa no padrão do sistema', () async {
    final repo = SettingsRepository();

    expect(await repo.carregarIdioma(), isNull);
  });

  test('salva e recarrega o idioma', () async {
    final repo = SettingsRepository();
    await repo.salvarIdioma(const Locale('en'));

    expect(await repo.carregarIdioma(), const Locale('en'));
  });

  test('salvar null volta ao padrão do sistema', () async {
    final repo = SettingsRepository();
    await repo.salvarIdioma(const Locale('es'));
    await repo.salvarIdioma(null);

    expect(await repo.carregarIdioma(), isNull);
  });

  test('valor "system" armazenado é tratado como padrão do sistema', () async {
    SharedPreferences.setMockInitialValues({'idioma': 'system'});
    final repo = SettingsRepository();

    expect(await repo.carregarIdioma(), isNull);
  });

  test('tema continua funcionando', () async {
    final repo = SettingsRepository();
    await repo.salvarTema(ThemeMode.dark);

    expect(await repo.carregarTema(), ThemeMode.dark);
  });
}