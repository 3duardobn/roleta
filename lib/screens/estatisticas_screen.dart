import 'package:flutter/material.dart';
import 'package:roleta/l10n/app_localizations.dart';
import 'package:roleta/models/caixa.dart';

class EstatisticasScreen extends StatelessWidget {
  const EstatisticasScreen({super.key, required this.caixa});

  final Caixa caixa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final contagens = caixa.contagens;
    final total = contagens.values.fold<int>(0, (acc, c) => acc + c);
    final itens = caixa.palavras.map((palavra) {
      final count = contagens[palavra] ?? 0;
      return (palavra, count);
    }).toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: caixa.palavras.isEmpty || total == 0
          ? Center(child: Text(l10n.statsEmpty))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.statsTotal(total),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                for (final (palavra, count) in itens)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: const Icon(Icons.policy_outlined),
                    title: Text(palavra),
                    trailing: Text(
                      l10n.statsDraws(count),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
              ],
            ),
    );
  }
}