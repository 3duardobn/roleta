import 'package:flutter_test/flutter_test.dart';
import 'package:roleta/models/caixa.dart';

void main() {
  group('Caixa', () {
    test('nova gera ids diferentes e lista própria', () {
      final c1 = Caixa.nova(nome: 'A', palavras: ['x']);
      final c2 = Caixa.nova(nome: 'B', palavras: ['y']);

      expect(c1.id, isNot(equals(c2.id)));
      expect(c1.palavras, ['x']);
      expect(c2.palavras, ['y']);
    });

    test('toJson/fromJson preserva os dados (round-trip)', () {
      final caixa = Caixa(
        id: 'abc',
        nome: 'Nomes',
        palavras: ['Maria', 'João'],
      );

      final restaurada = Caixa.fromJson(caixa.toJson());

      expect(restaurada.id, 'abc');
      expect(restaurada.nome, 'Nomes');
      expect(restaurada.palavras, ['Maria', 'João']);
    });

    test('fromJson tolera campos ausentes', () {
      final caixa = Caixa.fromJson(const {});

      expect(caixa.nome, '');
      expect(caixa.palavras, isEmpty);
      expect(caixa.id, isNotEmpty);
    });

    test('fromJson ignora tipos inválidos em palavras', () {
      final caixa = Caixa.fromJson(const {
        'id': 'x',
        'nome': 'N',
        'palavras': ['a', 42, true, null],
      });

      expect(caixa.palavras, ['a', '42', 'true', 'null']);
    });

    test('copia não compartilha a lista de palavras', () {
      final caixa = Caixa(id: '1', nome: 'N', palavras: ['a']);
      final copia = caixa.copia();

      copia.palavras.add('b');

      expect(caixa.palavras, ['a']);
      expect(copia.palavras, ['a', 'b']);
    });

    test('toJson/fromJson preserva contagens e opções', () {
      final caixa = Caixa(
        id: 'abc',
        nome: 'Nomes',
        palavras: ['Maria', 'João'],
        contagens: {'Maria': 3},
        evitarRepeticao: true,
        desativarAoSortear: true,
      );

      final restaurada = Caixa.fromJson(caixa.toJson());

      expect(restaurada.contagens, {'Maria': 3});
      expect(restaurada.evitarRepeticao, isTrue);
      expect(restaurada.desativarAoSortear, isTrue);
    });

    test('fromJson tolera a ausência das novas opções', () {
      final caixa = Caixa.fromJson(const {
        'id': 'x',
        'nome': 'N',
        'palavras': ['a'],
      });

      expect(caixa.contagens, isEmpty);
      expect(caixa.evitarRepeticao, isFalse);
      expect(caixa.desativarAoSortear, isFalse);
    });

    test('registrarSorteio incrementa a contagem da palavra', () {
      final caixa = Caixa(id: '1', nome: 'N', palavras: ['a', 'b']);

      caixa.registrarSorteio('a');
      caixa.registrarSorteio('a');

      expect(caixa.contagens['a'], 2);
      expect(caixa.contagens.containsKey('b'), isFalse);
    });
  });
}