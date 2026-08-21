import 'package:flutter/material.dart';
import 'package:roleta/l10n/app_localizations.dart';

/// Mostra um diálogo de confirmação padrão. Retorna `true` somente se o
/// usuário confirmar.
Future<bool> confirmarAcao(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmar = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmar == true;
}
