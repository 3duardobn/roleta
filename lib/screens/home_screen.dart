import 'package:flutter/material.dart';
import 'package:roleta/data/app_preferences.dart';
import 'package:roleta/data/caixa_repository.dart';
import 'package:roleta/l10n/app_localizations.dart';
import 'package:roleta/models/caixa.dart';
import 'package:roleta/screens/caixa_form_screen.dart';
import 'package:roleta/screens/estatisticas_screen.dart';
import 'package:roleta/screens/roleta_screen.dart';
import 'package:roleta/screens/settings_screen.dart';
import 'package:roleta/widgets/confirm_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.repository,
    required this.settings,
  });

  final CaixaRepository repository;
  final AppPreferences settings;

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

  Future<void> _abrirConfiguracoes() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          settings: widget.settings,
          repository: widget.repository,
        ),
      ),
    );
  }

  Future<void> _abrirEstatisticas(Caixa caixa) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EstatisticasScreen(caixa: caixa),
      ),
    );
  }

  Future<void> _excluir(Caixa caixa) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmar = await confirmarAcao(
      context,
      title: l10n.deleteRouletteTitle,
      message: l10n.deleteRouletteMessage(caixa.nome),
      confirmLabel: l10n.delete,
    );
    if (!confirmar || !mounted) return;

    final caixas = List<Caixa>.of(_caixas ?? [])
      ..removeWhere((c) => c.id == caixa.id);
    await widget.repository.salvarTodas(caixas);
    setState(() => _caixas = caixas);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            onPressed: _abrirConfiguracoes,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirForm(),
        icon: const Icon(Icons.add),
        label: Text(l10n.newRoulette),
      ),
      body: Column(
        children: [
          ListenableBuilder(
            listenable: widget.settings,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l10n.themeSystem),
                    icon: const Icon(Icons.brightness_auto),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l10n.themeLight),
                    icon: const Icon(Icons.light_mode),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l10n.themeDark),
                    icon: const Icon(Icons.dark_mode),
                  ),
                ],
                selected: {widget.settings.themeMode},
                onSelectionChanged: (selection) {
                  widget.settings.setThemeMode(selection.first);
                },
              ),
            ),
          ),
          Expanded(child: _corpo(l10n)),
        ],
      ),
    );
  }

  Widget _corpo(AppLocalizations l10n) {
    final caixas = _caixas;
    if (caixas == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (caixas.isEmpty) {
      return Center(
        child: Text(
          l10n.emptyState,
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
            subtitle: Text(l10n.wordCount(caixa.palavras.length)),
            trailing: PopupMenuButton<String>(
              onSelected: (acao) {
                switch (acao) {
                  case 'editar':
                    _abrirForm(caixa);
                  case 'excluir':
                    _excluir(caixa);
                  case 'estatisticas':
                    _abrirEstatisticas(caixa);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'editar', child: Text(l10n.edit)),
                PopupMenuItem(value: 'estatisticas', child: Text(l10n.statsTitle)),
                PopupMenuItem(value: 'excluir', child: Text(l10n.delete)),
              ],
            ),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RoletaScreen(
                    caixa: caixa,
                    repository: widget.repository,
                  ),
                ),
              );
              _carregar();
            },
          ),
        );
      },
    );
  }
}