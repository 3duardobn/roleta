import 'dart:math';

class Caixa {
  Caixa({
    required this.id,
    required this.nome,
    required this.palavras,
    Map<String, int>? contagens,
    this.evitarRepeticao = false,
    this.desativarAoSortear = false,
  }) : contagens = Map.of(contagens ?? const {});

  final String id;
  String nome;
  List<String> palavras;

  /// Quantas vezes cada palavra foi sorteada (estatísticas).
  Map<String, int> contagens;

  /// Não sorteia a mesma palavra duas vezes seguidas.
  bool evitarRepeticao;

  /// Remove a palavra do sorteio quando ela é sorteada (sorteio que diminui).
  bool desativarAoSortear;

  factory Caixa.nova({required String nome, List<String> palavras = const []}) {
    return Caixa(
      id: _uuid(),
      nome: nome,
      palavras: List.of(palavras),
    );
  }

  factory Caixa.fromJson(Map<String, dynamic> json) {
    final contagens = <String, int>{};
    (json['contagens'] as Map<dynamic, dynamic>? ?? const {})
        .forEach((palavra, valor) {
      final p = palavra.toString();
      final v = valor is int ? valor : int.tryParse(valor.toString());
      if (v != null) contagens[p] = v;
    });
    return Caixa(
      id: json['id'] as String? ?? _uuid(),
      nome: json['nome'] as String? ?? '',
      palavras: (json['palavras'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      contagens: contagens,
      evitarRepeticao: json['evitarRepeticao'] as bool? ?? false,
      desativarAoSortear: json['desativarAoSortear'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'palavras': palavras,
        'contagens': contagens,
        'evitarRepeticao': evitarRepeticao,
        'desativarAoSortear': desativarAoSortear,
      };

  Caixa copia() => Caixa(
        id: id,
        nome: nome,
        palavras: List.of(palavras),
        contagens: Map.of(contagens),
        evitarRepeticao: evitarRepeticao,
        desativarAoSortear: desativarAoSortear,
      );

  /// Registra um sorteio de [palavra] nas estatísticas.
  void registrarSorteio(String palavra) {
    contagens[palavra] = (contagens[palavra] ?? 0) + 1;
  }

  static String _uuid() {
    final rng = Random.secure();
    final hex = List.generate(16, (_) => rng.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
    return '$hex-${DateTime.now().microsecondsSinceEpoch}';
  }
}