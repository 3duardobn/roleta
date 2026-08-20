import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roleta/data/caixa_repository.dart';
import 'package:roleta/data/settings_repository.dart';
import 'package:roleta/l10n/app_localizations.dart';
import 'package:roleta/main.dart';
import 'package:roleta/models/caixa.dart';
import 'package:roleta/screens/roleta_screen.dart';
import 'package:roleta/services/shake_detector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeShakeDetector extends ShakeDetector {
  _FakeShakeDetector();

  final controller = StreamController<void>.broadcast();

  @override
  Stream<void> get onShake => controller.stream;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.instance.platformDispatcher.localesTestValue = [
      const Locale('pt'),
    ];
  });

  Future<void> sortear(WidgetTester tester) async {
    await tester.tap(find.byType(FilledButton));
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pump();
  }

  testWidgets('sorteio registra a contagem exatamente da palavra exibida',
      (tester) async {
    final repo = CaixaRepository();
    final caixa = Caixa.nova(nome: 'Nomes', palavras: ['A', 'B', 'C']);
    await repo.salvarCaixa(caixa);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RoletaScreen(
          caixa: caixa,
          repository: repo,
          shakeDetectorBuilder: _FakeShakeDetector.new,
        ),
      ),
    );

    await sortear(tester);

    final resultado = find.textContaining(RegExp(r'^(A|B|C)$')).evaluate().last;
    final palavra = (resultado.widget as Text).data!;
    expect(['A', 'B', 'C'], contains(palavra));

    final salvas = await repo.carregarTodas();
    expect(salvas.single.contagens[palavra], 1);
    expect(salvas.single.contagens.values.fold<int>(0, (a, b) => a + b), 1);
  });

  testWidgets('sorteios repetidos acumulam a contagem', (tester) async {
    final repo = CaixaRepository();
    final caixa = Caixa.nova(nome: 'Nomes', palavras: ['A', 'B', 'C']);
    await repo.salvarCaixa(caixa);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RoletaScreen(
          caixa: caixa,
          repository: repo,
          shakeDetectorBuilder: _FakeShakeDetector.new,
        ),
      ),
    );

    for (var i = 0; i < 4; i++) {
      await sortear(tester);
    }

    final salvas = await repo.carregarTodas();
    expect(salvas.single.contagens.values.fold<int>(0, (a, b) => a + b), 4);
  });

  testWidgets('fluxo completo: sorteio, voltar e abrir estatísticas',
      (tester) async {
    final repo = CaixaRepository();
    await repo.salvarCaixa(
      Caixa.nova(nome: 'Nomes', palavras: ['A', 'B', 'C']),
    );

    await tester.pumpWidget(RoletaApp(repository: repo, settings: SettingsRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Nomes'));
    await tester.pumpAndSettle();
    expect(find.text('Sortear'), findsOneWidget);

    // A RoletaScreen real usa sensors_plus; em teste o shake é ignorado,
    // mas o botão Sortear funciona normalmente.
    await sortear(tester);

    // volta para a home
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // abre o menu e as estatísticas
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Estatísticas'));
    await tester.pumpAndSettle();

    expect(find.text('Estatísticas'), findsOneWidget);
    expect(find.text('1 sorteio no total'), findsOneWidget);
  });
}