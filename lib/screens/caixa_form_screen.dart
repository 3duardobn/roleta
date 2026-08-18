import 'package:flutter/material.dart';

import '../data/caixa_repository.dart';
import '../models/caixa.dart';

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
    final nome = _nomeController.text.trim();
    final palavras = _palavraControllers
        .map((c) => c.text.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    if (nome.isEmpty) {
      _mostrarErro('Informe um nome para a roleta.');
      return;
    }
    if (palavras.isEmpty) {
      _mostrarErro('Adicione pelo menos uma palavra.');
      return;
    }

    final caixa = widget.caixa?.copia() ?? Caixa.nova(nome: nome);
    caixa.nome = nome;
    caixa.palavras = palavras;

    final todas = await widget.repository.carregarTodas();
    if (_editando) {
      final i = todas.indexWhere((c) => c.id == caixa.id);
      if (i >= 0) {
        todas[i] = caixa;
      } else {
        todas.add(caixa);
      }
    } else {
      todas.add(caixa);
    }
    await widget.repository.salvarTodas(todas);

    if (mounted) Navigator.of(context).pop();
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _confirmarExcluirPalavra(int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir palavra?'),
        content: const Text('Esta palavra será removida da roleta.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;

    setState(() {
      _palavraControllers[index].dispose();
      _palavraControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar roleta' : 'Nova roleta'),
        actions: [
          TextButton(onPressed: _salvar, child: const Text('Salvar')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome da roleta',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Palavras',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(
                  () => _palavraControllers.add(TextEditingController()),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Adicionar'),
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
                        labelText: 'Palavra ${i + 1}',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Excluir palavra',
                    onPressed: () => _confirmarExcluirPalavra(i),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
