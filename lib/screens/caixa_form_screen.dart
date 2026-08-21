import 'package:flutter/material.dart';
import 'package:roleta/data/caixa_repository.dart';
import 'package:roleta/l10n/app_localizations.dart';
import 'package:roleta/models/caixa.dart';
import 'package:roleta/widgets/confirm_dialog.dart';

class CaixaFormScreen extends StatefulWidget {
  const CaixaFormScreen({super.key, required this.repository, this.caixa});

  final CaixaRepository repository;
  final Caixa? caixa;

  @override
  State<CaixaFormScreen> createState() => _CaixaFormScreenState();
}

class _CaixaFormScreenState extends State<CaixaFormScreen> {
  late final TextEditingController _nomeController;
  late final List<TextEditingController> _palavraControllers;
  late bool _evitarRepeticao;
  late bool _desativarAoSortear;

  bool get _editando => widget.caixa != null;

  @override
  void initState() {
    super.initState();
    final caixa = widget.caixa;
    _nomeController = TextEditingController(text: caixa?.nome ?? '');
    final palavras = caixa?.palavras ?? const <String>[];
    _palavraControllers = palavras.isEmpty
        ? [TextEditingController()]
        : palavras.map((p) => TextEditingController(text: p)).toList();
    _evitarRepeticao = caixa?.evitarRepeticao ?? false;
    _desativarAoSortear = caixa?.desativarAoSortear ?? false;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    for (final controller in _palavraControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    final l10n = AppLocalizations.of(context)!;
    final nome = _nomeController.text.trim();
    final palavras = _palavraControllers
        .map((c) => c.text.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    if (nome.isEmpty) {
      _mostrarErro(l10n.errorNameEmpty);
      return;
    }
    if (palavras.isEmpty) {
      _mostrarErro(l10n.errorWordEmpty);
      return;
    }

    final caixa = (widget.caixa?.copia() ?? Caixa.nova(nome: nome))
      ..nome = nome
      ..palavras = palavras
      ..evitarRepeticao = _evitarRepeticao
      ..desativarAoSortear = _desativarAoSortear;

    try {
      await widget.repository.salvarCaixa(caixa);
    } catch (_) {
      if (mounted) _mostrarErro(l10n.saveError);
      return;
    }

    if (mounted) Navigator.of(context).pop();
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _confirmarExcluirPalavra(int index) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmar = await confirmarAcao(
      context,
      title: l10n.deleteWordTitle,
      message: l10n.deleteWordMessage,
      confirmLabel: l10n.delete,
    );
    if (!confirmar || !mounted) return;

    setState(() {
      _palavraControllers[index].dispose();
      _palavraControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? l10n.formTitleEdit : l10n.formTitleNew),
        actions: [
          TextButton(onPressed: _salvar, child: Text(l10n.save)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nomeController,
            decoration: InputDecoration(
              labelText: l10n.nameLabel,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.wordsLabel,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(
                  () => _palavraControllers.add(TextEditingController()),
                ),
                icon: const Icon(Icons.add),
                label: Text(l10n.add),
              ),
            ],
          ),
          for (var i = 0; i < _palavraControllers.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _palavraControllers[i],
                      decoration: InputDecoration(
                        labelText: l10n.wordLabel(i + 1),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.deleteWordTooltip,
                    onPressed: () => _confirmarExcluirPalavra(i),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          SwitchListTile(
            value: _evitarRepeticao,
            onChanged: (v) => setState(() => _evitarRepeticao = v),
            title: Text(l10n.avoidRepeatLabel),
            subtitle: Text(l10n.avoidRepeatSub),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            value: _desativarAoSortear,
            onChanged: (v) => setState(() => _desativarAoSortear = v),
            title: Text(l10n.deactivateLabel),
            subtitle: Text(l10n.deactivateSub),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
