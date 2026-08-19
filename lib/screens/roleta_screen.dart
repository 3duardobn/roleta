import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:roleta/data/caixa_repository.dart';
import 'package:roleta/l10n/app_localizations.dart';
import 'package:roleta/models/caixa.dart';
import 'package:roleta/services/shake_detector.dart';
import 'package:roleta/services/sorteio_service.dart';

class RoletaScreen extends StatefulWidget {
  const RoletaScreen({
    super.key,
    required this.caixa,
    required this.repository,
    this.sorteioService = const SorteioService(),
    this.shakeDetectorBuilder,
  });

  final Caixa caixa;
  final CaixaRepository repository;
  final SorteioService sorteioService;

  /// Permite injetar um detector falso nos testes.
  final ShakeDetector Function()? shakeDetectorBuilder;

  @override
  State<RoletaScreen> createState() => _RoletaScreenState();
}

class _RoletaScreenState extends State<RoletaScreen> {
  final _random = Random();
  Timer? _timer;
  ShakeDetector? _shake;

  late Caixa _caixa;
  String? _ultimaSorteada;
  final Set<String> _desativadas = {};

  String? _palavraAtual;
  String? _resultado;
  bool _rodando = false;
  int _passo = 0;
  late List<Duration> _intervalos;

  @override
  void initState() {
    super.initState();
    _caixa = widget.caixa.copia();
    _shake = (widget.shakeDetectorBuilder ?? ShakeDetector.new)();
    _shake!.onShake.listen((_) => _sortear());
    if (_caixa.palavras.isNotEmpty) {
      _palavraAtual = _caixa.palavras.first;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Acelera e depois desacelera, totalizando ~2,3s de flash.
  List<Duration> _gerarIntervalos() {
    final intervalos = <Duration>[];
    for (var i = 0; i < 12; i++) {
      intervalos.add(Duration(milliseconds: 150 - i * 8));
    }
    for (var i = 0; i < 10; i++) {
      intervalos.add(Duration(milliseconds: 60 + i * 10));
    }
    return intervalos;
  }

  /// Retorna as palavras que podem ser sorteadas, aplicando as opções.
  List<String> _disponiveis() {
    final palavras = _caixa.palavras;
    final excluidos = <String>{};
    if (_caixa.desativarAoSortear) excluidos.addAll(_desativadas);
    if (_caixa.evitarRepeticao && _ultimaSorteada != null) {
      excluidos.add(_ultimaSorteada!);
    }
    var disponiveis = palavras.where((p) => !excluidos.contains(p)).toList();

    if (disponiveis.isEmpty) {
      if (_caixa.desativarAoSortear && _desativadas.isNotEmpty) {
        _desativadas.clear();
        final apenasUltima = <String>{};
        if (_caixa.evitarRepeticao && _ultimaSorteada != null) {
          apenasUltima.add(_ultimaSorteada!);
        }
        disponiveis = palavras.where((p) => !apenasUltima.contains(p)).toList();
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(l10n.allWordsDrawn)));
      } else {
        // Não é possível evitar a repetição (ex.: uma única palavra).
        disponiveis = List.of(palavras);
      }
    }
    return disponiveis;
  }

  void _sortear() {
    final palavras = _caixa.palavras;
    if (palavras.isEmpty || _rodando) return;

    final disponiveis = _disponiveis();
    final sorteada = widget.sorteioService.sortear(disponiveis, _random);
    setState(() {
      _rodando = true;
      _resultado = null;
      _intervalos = _gerarIntervalos();
      _passo = 0;
    });
    _agendarPasso(sorteada);
  }

  void _agendarPasso(String sorteada) {
    if (_passo >= _intervalos.length) {
      _caixa.registrarSorteio(sorteada);
      if (_caixa.desativarAoSortear) _desativadas.add(sorteada);
      _ultimaSorteada = sorteada;
      widget.repository.salvarCaixa(_caixa);
      setState(() {
        _palavraAtual = sorteada;
        _resultado = sorteada;
        _rodando = false;
      });
      return;
    }
    _timer = Timer(_intervalos[_passo], () {
      if (!mounted) return;
      setState(() {
        _palavraAtual =
            _caixa.palavras[_random.nextInt(_caixa.palavras.length)];
      });
      _passo++;
      _agendarPasso(sorteada);
    });
  }

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    final palavras = _caixa.palavras;
    final semPalavras = palavras.isEmpty;
    final texto = _resultado ?? _palavraAtual;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(_caixa.nome)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_caixa.desativarAoSortear && palavras.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l10n.remainingWords(palavras.length - _desativadas.length,
                      palavras.length),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    texto ?? '—',
                    key: ValueKey(texto),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _resultado != null ? 48 : 36,
                      fontWeight: FontWeight.bold,
                      color: _resultado != null ? colorScheme.primary : null,
                    ),
                  ),
                ),
              ),
            ),
            if (_resultado != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l10n.drawnMessage,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            if (semPalavras)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  l10n.noWords,
                  textAlign: TextAlign.center,
                ),
              ),
            FilledButton.icon(
              onPressed: semPalavras || _rodando ? null : _sortear,
              icon: const Icon(Icons.casino),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(_rodando ? l10n.drawing : l10n.draw),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.shakeTip,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}