import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:roleta/data/caixa_repository.dart';
import 'package:roleta/data/settings_repository.dart';
import 'package:roleta/l10n/app_localizations.dart';
import 'package:roleta/services/backup_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.settings,
    required this.locale,
    required this.onLocaleChanged,
    required this.repository,
    this.backupService = const BackupService(),
  });

  final SettingsRepository settings;
  final Locale? locale;
  final ValueChanged<Locale?> onLocaleChanged;
  final CaixaRepository repository;
  final BackupService backupService;

  Future<void> _abrirGitHub() async {
    await launchUrl(Uri.parse('https://github.com/3duardobn/roleta'));
  }

  Future<void> _abrirSite() async {
    await launchUrl(Uri.parse('https://edbn.dev'));
  }

  Future<void> _abrirContato() async {
    await launchUrl(Uri.parse('mailto:edbn_dev@pm.me'));
  }

  Future<void> _exportar(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final caixas = await repository.carregarTodas();
    if (!context.mounted) return;
    if (caixas.isEmpty) {
      _mostrarMensagem(context, l10n.exportEmpty);
      return;
    }

    final opcao = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.ios_share),
              title: Text(l10n.exportShare),
              onTap: () => Navigator.pop(context, 'share'),
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: Text(l10n.exportSave),
              onTap: () => Navigator.pop(context, 'save'),
            ),
          ],
        ),
      ),
    );
    if (opcao == null || !context.mounted) return;

    final json = backupService.gerarJson(caixas);
    switch (opcao) {
      case 'share':
        await _compartilhar(context, l10n, json);
      case 'save':
        await _salvarArquivo(context, l10n, json);
    }
  }

  Future<void> _compartilhar(
      BuildContext context, AppLocalizations l10n, String json) async {
    try {
      final dir = Directory.systemTemp;
      final arquivo = File('${dir.path}/roleta_backup.json');
      await arquivo.writeAsString(json);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(arquivo.path)], subject: l10n.exportSubject),
      );
    } catch (_) {
      if (context.mounted) _mostrarMensagem(context, l10n.exportError);
    }
  }

  Future<void> _salvarArquivo(
      BuildContext context, AppLocalizations l10n, String json) async {
    try {
      final caminho = await FilePicker.saveFile(
        dialogTitle: l10n.exportSave,
        fileName: 'roleta_backup.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: utf8.encode(json),
      );
      if (caminho != null && context.mounted) {
        _mostrarMensagem(context, l10n.exportSuccess);
      }
    } catch (_) {
      if (context.mounted) _mostrarMensagem(context, l10n.exportError);
    }
  }

  Future<void> _importar(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final arquivo = await FilePicker.pickFile(
        dialogTitle: l10n.import,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (arquivo == null) return;
      final conteudo = await arquivo.xFile.readAsString();
      if (!context.mounted) return;

      final importadas = backupService.importar(conteudo);
      if (importadas.isEmpty) {
        _mostrarMensagem(context, l10n.importError);
        return;
      }

      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.importTitle),
          content: Text(l10n.importMessage(importadas.length)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.import),
            ),
          ],
        ),
      );
      if (confirmar != true || !context.mounted) return;

      await repository.salvarTodas(importadas);
      if (context.mounted) {
        _mostrarMensagem(context, l10n.importSuccess(importadas.length));
      }
    } catch (_) {
      if (context.mounted) _mostrarMensagem(context, l10n.importError);
    }
  }

  void _mostrarMensagem(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              l10n.languageSection,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(l10n.languageSub),
          ),
          RadioGroup<Locale?>(
            groupValue: locale,
            onChanged: onLocaleChanged,
            child: Column(
              children: [
                RadioListTile<Locale?>(
                  value: null,
                  title: Text(l10n.langSystem),
                ),
                const RadioListTile<Locale?>(
                  value: Locale('pt'),
                  title: Text('Português'),
                ),
                const RadioListTile<Locale?>(
                  value: Locale('en'),
                  title: Text('English'),
                ),
                const RadioListTile<Locale?>(
                  value: Locale('es'),
                  title: Text('Español'),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              l10n.backupSection,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(l10n.backupSub),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _exportar(context),
                  icon: const Icon(Icons.upload_file),
                  label: Text(l10n.export),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _importar(context),
                  icon: const Icon(Icons.download),
                  label: Text(l10n.import),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              l10n.licenseSection,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.licenseText),
                const SizedBox(height: 8),
                _link(context, l10n.licenseGithub, _abrirGitHub),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              l10n.contactSection,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(l10n.contactSub),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _link(context, l10n.contactSite, _abrirSite),
                const SizedBox(height: 8),
                _link(context, l10n.contactEmail, _abrirContato),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _link(BuildContext context, String texto, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Text(
        texto,
        style: TextStyle(
          color: isDark ? const Color(0xFF90CAF9) : const Color(0xFF1565C0),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}