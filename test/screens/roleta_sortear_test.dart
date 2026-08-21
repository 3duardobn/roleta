import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roleta/data/caixa_repository.dart';
import 'package:roleta/l10n/app_localizations.dart';
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

  Future<String?> sortear(WidgetTester tester) async {
    await tester.tap(find.byType(FilledButton));
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pump();
    final resultado = find.textContaining(RegExp(r'^(A|B|C|D)$'));
    if (resultado.evaluate().isEmpty) return null;
    return (resultado.evaluate().last.widget as Text).data;
  }

  Future<void> bombear(WidgetTester tester, Caixa caixa) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RoletaScreen(
          caixa: caixa,
          repository: CaixaRepository(),
          shakeDetectorBuilder: _FakeShakeDetector.new,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('evitarRepeticao não sorteia a mesma palavra em sequência',
      (tester) async {
    await bombear(
      tester,
      Caixa.nova(nome: 'Nomes', palavras: ['A', 'B', 'C'])
        ..evitarRepeticao = true,
    );

    var anterior = await sortear(tester);
    for (var i = 0; i < 10; i++) {
      final atual = await sortear(tester);
      expect(atual, isNotNull);
      expect(atual, isNot(anterior));
      anterior = atual;
    }
  });

  testWidgets('desativarAoSortear esgota as palavras e recomeça o ciclo',
      (tester) async {
    final repo = CaixaRepository();
    final caixa = Caixa.nova(nome: 'Nomes', palavras: ['A', 'B'])
      ..desativarAoSortear = true;
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
    await tester.pumpAndSettle();

    // 1º sorteio: falta 1 palavra de 2
    await sortear(tester);
    expect(find.text('Falta 1 palavra de 2'), findsOneWidget);

    // 2º sorteio: zera o restante
    await sortear(tester);
    expect(find.text('Nenhuma palavra restante de 2'), findsOneWidget);

    // 3º sorteio: recomeça e avisa com um SnackBar
    await sortear(tester);
    expect(find.textContaining('Recomeçando'), findsOneWidget);

    // todas as palavras voltam a estar disponíveis
    final salvas = await repo.carregarTodas();
    expect(salvas.single.contagens.values.fold<int>(0, (a, b) => a + b), 3);
  });

  testWidgets('falha ao salvar não trava o botão de sortear',
      (tester) async {
    final repo = _RepoQueFalha();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RoletaScreen(
          caixa: Caixa.nova(nome: 'Nomes', palavras: ['A', 'B']),
          repository: repo,
          shakeDetectorBuilder: _FakeShakeDetector.new,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await sortear(tester);

    // o botão volta a ficar habilitado mesmo com erro de persistência
    final botao =
        tester.widget<FilledButton>(find.byType(FilledButton));
    expect(botao.onPressed, isNotNull);
    expect(find.textContaining('Não foi possível salvar'), findsOneWidget);
  });
}

class _RepoQueFalha extends CaixaRepository {
  @override
  Future<void> salvarCaixa(Caixa caixa) async {
    throw Exception('falha simulada');
  }
}
