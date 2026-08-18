import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/caixa.dart';

class CaixaRepository {
  static const _storageKey = 'caixas';

  Future<List<Caixa>> carregarTodas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final lista = jsonDecode(raw) as List<dynamic>;
      return lista
          .map((e) => Caixa.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> salvarTodas(List<Caixa> caixas) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(caixas.map((c) => c.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
