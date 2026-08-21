import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roleta/l10n/app_localizations.dart';
import 'package:roleta/models/caixa.dart';
import 'package:roleta/screens/estatisticas_screen.dart';

void main() {
  testWidgets('palavra nunca sorteada mostra 0 vezes, não 1 (bug de plural pt)',
      (tester) async {
    tester.binding.platformDispatcher.localesTestValue = [const Locale('pt')];
    final caixa = Caixa.nova(nome: 'Nomes', palavras: ['A', 'B', 'C'])
      ..registrarSorteio('A');

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: EstatisticasScreen(caixa: caixa),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 sorteio no total'), findsOneWidget);
    expect(find.text('1 vez'), findsOneWidget);
    expect(find.text('0 vezes'), findsNWidgets(2));
  });
}
