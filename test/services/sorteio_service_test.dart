import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:roleta/services/sorteio_service.dart';

void main() {
  const service = SorteioService();

  group('sortear', () {
    test('retorna uma palavra que existe na lista', () {
      final palavras = ['A', 'B', 'C', 'D'];

      for (var seed = 0; seed < 100; seed++) {
        final sorteada = service.sortear(palavras, Random(seed));
        expect(palavras, contains(sorteada));
      }
    });

    test('é determinístico com o mesmo random', () {
      final palavras = ['A', 'B', 'C', 'D'];

      final a = service.sortear(palavras, Random(7));
      final b = service.sortear(palavras, Random(7));

      expect(a, b);
    });

    test('lança exceção com lista vazia', () {
      expect(
        () => service.sortear(const [], Random(1)),
        throwsA(isA<SorteioException>()),
      );
    });
  });

  group('sortearIndice', () {
    test('respeita os limites da lista', () {
      final palavras = List.generate(100, (i) => 'p$i');

      for (var seed = 0; seed < 100; seed++) {
        final idx = service.sortearIndice(palavras, Random(seed));
        expect(idx, inInclusiveRange(0, 99));
      }
    });

    test('com lista de um elemento sempre retorna 0', () {
      expect(service.sortearIndice(['única'], Random(0)), 0);
      expect(service.sortearIndice(['única'], Random(999)), 0);
    });

    test('lança exceção com lista vazia', () {
      expect(
        () => service.sortearIndice(const [], Random(1)),
        throwsA(isA<SorteioException>()),
      );
    });
  });
}