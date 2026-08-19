import 'package:flutter/material.dart';
import 'package:roleta/data/settings_repository.dart';
import 'package:roleta/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.settings,
    required this.locale,
    required this.onLocaleChanged,
  });

  final SettingsRepository settings;
  final Locale? locale;
  final ValueChanged<Locale?> onLocaleChanged;

  Future<void> _abrirGitHub() async {
    await launchUrl(Uri.parse('https://github.com/3duardobn/roleta'));
  }

  Future<void> _abrirSite() async {
    await launchUrl(Uri.parse('https://edbn.dev'));
  }

  Future<void> _abrirContato() async {
    await launchUrl(Uri.parse('mailto:edbn_dev@pm.me'));
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
              l10n.freeCodeSection,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.freeCodeText),
                const SizedBox(height: 8),
                _link(l10n.freeCodeGithub, _abrirGitHub),
                const SizedBox(height: 4),
                _link(l10n.freeCodeSite, _abrirSite),
                const SizedBox(height: 4),
                _link(l10n.freeCodeContact, _abrirContato),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _link(String texto, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        texto,
        style: const TextStyle(
          color: Color(0xFF1565C0),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}