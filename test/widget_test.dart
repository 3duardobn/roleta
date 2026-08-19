import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roleta/data/caixa_repository.dart';
import 'package:roleta/data/settings_repository.dart';
import 'package:roleta/main.dart';
import 'package:roleta/models/caixa.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.instance.platformDispatcher.localesTestValue = [
      const Locale('pt'),
    ];
  });

  Future<void> bombearApp(WidgetTester tester, CaixaRepository repo) async {
    tester.binding.platformDispatcher.localesTestValue = [const Locale('pt')];
    await tester.pumpWidget(
      RoletaApp(repository: repo, settings: SettingsRepository()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('home exibe as roletas salvas', (tester) async {
    final repo = CaixaRepository();
    await repo.salvarTodas([
      Caixa.nova(nome: 'Jantares', palavras: ['Pizza', 'Sushi']),
    ]);

    await bombearApp(tester, repo);

    expect(find.text('Jantares'), findsOneWidget);
    expect(find.text('2 palavras'), findsOneWidget);
  });

  testWidgets('home vazia mostra mensagem para criar roleta', (tester) async {
    final repo = CaixaRepository();

    await bombearApp(tester, repo);

    expect(find.textContaining('Nenhuma roleta ainda'), findsOneWidget);
  });

  testWidgets('excluir caixa pede confirmação', (tester) async {
    final repo = CaixaRepository();
    await repo.salvarTodas([
      Caixa.nova(nome: 'Jantares', palavras: ['Pizza']),
    ]);

    await bombearApp(tester, repo);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();

    expect(find.text('Excluir caixa?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Excluir'));
    await tester.pumpAndSettle();

    expect(find.text('Jantares'), findsNothing);
  });

  testWidgets('cancelar mantém a caixa', (tester) async {
    final repo = CaixaRepository();
    await repo.salvarTodas([
      Caixa.nova(nome: 'Jantares', palavras: ['Pizza']),
    ]);

    await bombearApp(tester, repo);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Jantares'), findsOneWidget);
  });

  testWidgets('configurações permite trocar o idioma', (tester) async {
    final repo = CaixaRepository();

    await bombearApp(tester, repo);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Configurações'), findsWidgets);
    expect(find.text('Padrão do sistema'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
    expect(find.text('System default'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('free-code'),
      100,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.textContaining('free-code'), findsOneWidget);
  });

  testWidgets('idioma escolhido é persistido e aplicado ao abrir o app',
      (tester) async {
    final repo = CaixaRepository();
    await repo.salvarTodas([
      Caixa.nova(nome: 'Jantares', palavras: ['Pizza']),
    ]);
    final settings = SettingsRepository();
    await settings.salvarIdioma(const Locale('en'));

    await tester.pumpWidget(
      RoletaApp(repository: repo, settings: settings),
    );
    await tester.pumpAndSettle();

    expect(find.text('Roulettes'), findsOneWidget);
    expect(find.text('1 word'), findsOneWidget);
  });
}
