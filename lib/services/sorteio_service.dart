import 'dart:math';

class SorteioService {
  const SorteioService();

  /// Sorteia uma palavra de [palavras] usando [random].
  ///
  /// Palavras em [excluidos] não participam do sorteio (ex.: a última
  /// sorteada ou palavras já removidas).
  ///
  /// Lança [SorteioException] quando a lista está vazia ou todas as palavras
  /// estão excluídas.
  String sortear(
    List<String> palavras, [
    Random? random,
    Set<String>? excluidos,
  ]) {
    final rng = random ?? Random();
    final disponiveis = _disponiveis(palavras, excluidos);
    if (disponiveis.isEmpty) {
      throw SorteioException('Nenhuma palavra disponível para sortear.');
    }
    return disponiveis[rng.nextInt(disponiveis.length)];
  }

  /// Retorna as palavras que podem ser sorteadas, excluindo [excluidos].
  List<String> _disponiveis(List<String> palavras, Set<String>? excluidos) {
    if (excluidos == null || excluidos.isEmpty) return palavras;
    return palavras.where((p) => !excluidos.contains(p)).toList();
  }
}

class SorteioException implements Exception {
  const SorteioException(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}
