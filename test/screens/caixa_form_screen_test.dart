import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roleta/data/caixa_repository.dart';
import 'package:roleta/l10n/app_localizations.dart';
import 'package:roleta/models/caixa.dart';
import 'package:roleta/screens/caixa_form_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.instance.platformDispatcher.localesTestValue = [
      const Locale('pt'),
    ];
  });

  Future<void> bombear(WidgetTester tester, CaixaRepository repo,
      {Caixa? caixa}) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CaixaFormScreen(repository: repo, caixa: caixa),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('não salva sem nome e mostra erro', (tester) async {
    final repo = CaixaRepository();
    await bombear(tester, repo);

    await tester.enterText(
        find.widgetWithText(TextField, 'Palavra 1'), 'A');
    await tester.tap(find.text('Salvar'));
    await tester.pump();

    expect(find.byType(CaixaFormScreen), findsOneWidget);
    expect(find.text('Informe um nome para a roleta.'), findsOneWidget);
    expect(await repo.carregarTodas(), isEmpty);
  });

  testWidgets('não salva sem palavras e mostra erro', (tester) async {
    final repo = CaixaRepository();
    await bombear(tester, repo);

    await tester.enterText(
        find.widgetWithText(TextField, 'Nome da roleta'), 'Minha roleta');
    await tester.tap(find.text('Salvar'));
    await tester.pump();

    expect(find.byType(CaixaFormScreen), findsOneWidget);
    expect(find.text('Adicione pelo menos uma palavra.'), findsOneWidget);
    expect(await repo.carregarTodas(), isEmpty);
  });

  testWidgets('cria uma nova caixa e fecha a tela', (tester) async {
    final repo = CaixaRepository();
    await bombear(tester, repo);

    await tester.enterText(
        find.widgetWithText(TextField, 'Nome da roleta'), 'Jantares');
    await tester.enterText(
        find.widgetWithText(TextField, 'Palavra 1'), 'Pizza');
    await tester.tap(find.text('Adicionar'));
    await tester.pump();
    await tester.enterText(
        find.widgetWithText(TextField, 'Palavra 2'), 'Sushi');

    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    final salvas = await repo.carregarTodas();
    expect(salvas, hasLength(1));
    expect(salvas.single.nome, 'Jantares');
    expect(salvas.single.palavras, ['Pizza', 'Sushi']);
  });

  testWidgets('edita uma caixa existente sem duplicar', (tester) async {
    final repo = CaixaRepository();
    final original = Caixa.nova(nome: 'Antiga', palavras: ['A']);
    await repo.salvarCaixa(original);

    await bombear(tester, repo, caixa: original);

    await tester.enterText(
        find.widgetWithText(TextField, 'Nome da roleta'), 'Nova');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    final salvas = await repo.carregarTodas();
    expect(salvas, hasLength(1));
    expect(salvas.single.id, original.id);
    expect(salvas.single.nome, 'Nova');
  });

  testWidgets('excluir palavra pede confirmação e remove', (tester) async {
    final repo = CaixaRepository();
    final caixa = Caixa.nova(nome: 'Nomes', palavras: ['A', 'B']);
    await bombear(tester, repo, caixa: caixa);

    await tester.tap(find.byTooltip('Excluir palavra').first);
    await tester.pumpAndSettle();

    // cancela primeiro
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Palavra 1'), findsOneWidget);

    await tester.tap(find.byTooltip('Excluir palavra').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir').last);
    await tester.pumpAndSettle();

    // sobra só a palavra B, que passa a ser rotulada "Palavra 1"
    expect(find.widgetWithText(TextField, 'A'), findsNothing);
    expect(find.widgetWithText(TextField, 'B'), findsOneWidget);
  });
}
