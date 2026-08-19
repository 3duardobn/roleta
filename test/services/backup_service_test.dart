import 'package:flutter_test/flutter_test.dart';
import 'package:roleta/models/caixa.dart';
import 'package:roleta/services/backup_service.dart';

void main() {
  const service = BackupService();

  test('gerarJson cria um backup válido com metadados', () {
    final caixas = [
      Caixa(id: '1', nome: 'Jantares', palavras: ['Pizza', 'Sushi']),
    ];

    final json = service.gerarJson(caixas);

    expect(json, contains('"app": "roleta"'));
    expect(json, contains('"version": 1'));
    expect(json, contains('"caixas"'));
  });

  test('importar recupera as caixas do JSON gerado (round-trip)', () {
    final caixas = [
      Caixa(
        id: '1',
        nome: 'Jantares',
        palavras: ['Pizza', 'Sushi'],
        contagens: {'Pizza': 2},
        evitarRepeticao: true,
      ),
      Caixa(id: '2', nome: 'Filmes', palavras: ['Ação']),
    ];

    final importadas = service.importar(service.gerarJson(caixas));

    expect(importadas.length, 2);
    expect(importadas[0].nome, 'Jantares');
    expect(importadas[0].palavras, ['Pizza', 'Sushi']);
    expect(importadas[0].contagens, {'Pizza': 2});
    expect(importadas[0].evitarRepeticao, isTrue);
    expect(importadas[1].nome, 'Filmes');
  });

  test('importar lança exceção com JSON inválido', () {
    expect(
      () => service.importar('{{não é json'),
      throwsA(isA<BackupException>()),
    );
  });

  test('importar lança exceção sem lista de caixas', () {
    expect(
      () => service.importar('{"app": "roleta"}'),
      throwsA(isA<BackupException>()),
    );
  });

  test('importar tolera caixas com formato legado (sem contagens/opções)', () {
    final json =
        '[{"id": "1", "nome": "N", "palavras": ["a", "b"]}]';
    final wrapper = '{"app": "roleta", "version": 1, "caixas": $json}';

    final importadas = service.importar(wrapper);

    expect(importadas.single.contagens, isEmpty);
    expect(importadas.single.evitarRepeticao, isFalse);
  });
}