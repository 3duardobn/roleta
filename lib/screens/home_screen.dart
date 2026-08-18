import 'package:flutter/material.dart';

import '../data/caixa_repository.dart';
import '../models/caixa.dart';
import 'caixa_form_screen.dart';
import 'roleta_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.repository,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final CaixaRepository repository;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Caixa>? _caixas;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final caixas = await widget.repository.carregarTodas();
    if (mounted) setState(() => _caixas = caixas);
  }

  Future<void> _abrirForm([Caixa? caixa]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CaixaFormScreen(repository: widget.repository, caixa: caixa),
      ),
    );
    _carregar();
  }

  Future<void> _excluir(Caixa caixa) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir caixa?'),
        content: Text(
          'Tem certeza que deseja excluir "${caixa.nome}"? '
          'Esta ação não pode ser desfeita.',
        ),
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

    final caixas = List<Caixa>.of(_caixas ?? [])
      ..removeWhere((c) => c.id == caixa.id);
    await widget.repository.salvarTodas(caixas);
    setState(() => _caixas = caixas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roletas')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirForm(),
        icon: const Icon(Icons.add),
        label: const Text('Nova roleta'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('Sistema'),
                  icon: Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Claro'),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Escuro'),
                  icon: Icon(Icons.dark_mode),
                ),
              ],
              selected: {widget.themeMode},
              onSelectionChanged: (selection) {
                widget.onThemeChanged(selection.first);
              },
            ),
          ),
          Expanded(child: _corpo()),
        ],
      ),
    );
  }

  Widget _corpo() {
    final caixas = _caixas;
    if (caixas == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (caixas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma roleta ainda.\nToque em "Nova roleta" para criar uma.',
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      itemCount: caixas.length,
      itemBuilder: (context, i) {
        final caixa = caixas[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(caixa.nome),
            subtitle: Text(
              '${caixa.palavras.length} '
              '${caixa.palavras.length == 1 ? 'palavra' : 'palavras'}',
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (acao) {
                switch (acao) {
                  case 'editar':
                    _abrirForm(caixa);
                  case 'excluir':
                    _excluir(caixa);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'editar', child: Text('Editar')),
                PopupMenuItem(value: 'excluir', child: Text('Excluir')),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => RoletaScreen(caixa: caixa)),
              );
            },
          ),
        );
      },
    );
  }
}
