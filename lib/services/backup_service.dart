import 'dart:convert';

import '../models/caixa.dart';

/// Gera e interpreta o backup JSON das caixas.
class BackupService {
  const BackupService();

  static const _versaoAtual = 1;

  /// Serializa [caixas] em um JSON legível com metadados do backup.
  String gerarJson(List<Caixa> caixas) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert({
      'app': 'roleta',
      'version': _versaoAtual,
      'exportadoEm': DateTime.now().toIso8601String(),
      'caixas': caixas.map((c) => c.toJson()).toList(),
    });
  }

  /// Converte [json] em uma lista de caixas.
  ///
  /// Lança [BackupException] quando o conteúdo não é um backup válido.
  List<Caixa> importar(String json) {
    final dynamic decodificado;
    try {
      decodificado = jsonDecode(json);
    } catch (_) {
      throw const BackupException('JSON inválido.');
    }
    if (decodificado is! Map<String, dynamic>) {
      throw const BackupException('Formato de backup inválido.');
    }
    final caixas = decodificado['caixas'];
    if (caixas is! List) {
      throw const BackupException('Nenhuma caixa no backup.');
    }
    return caixas
        .whereType<Map>()
        .map((c) => Caixa.fromJson(c.cast<String, dynamic>()))
        .toList();
  }
}

class BackupException implements Exception {
  const BackupException(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}