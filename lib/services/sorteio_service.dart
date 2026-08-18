import 'dart:math';

class SorteioService {
  const SorteioService();

  /// Sorteia uma palavra de [palavras] usando [random].
  ///
  /// Lança [SorteioException] quando a lista está vazia.
  String sortear(List<String> palavras, [Random? random]) {
    final rng = random ?? Random();
    if (palavras.isEmpty) {
      throw SorteioException('Nenhuma palavra para sortear.');
    }
    return palavras[rng.nextInt(palavras.length)];
  }

  /// Sorteia o índice de uma palavra de [palavras] usando [random].
  ///
  /// Lança [SorteioException] quando a lista está vazia.
  int sortearIndice(List<String> palavras, [Random? random]) {
    final rng = random ?? Random();
    if (palavras.isEmpty) {
      throw SorteioException('Nenhuma palavra para sortear.');
    }
    return rng.nextInt(palavras.length);
  }
}

class SorteioException implements Exception {
  const SorteioException(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}
