import 'package:flutter_test/flutter_test.dart';
import 'package:roleta/data/caixa_repository.dart';
import 'package:roleta/models/caixa.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('começa vazio quando não há dados salvos', () async {
    final repo = CaixaRepository();

    expect(await repo.carregarTodas(), isEmpty);
  });

  test('salva e recarrega as caixas', () async {
    final repo = CaixaRepository();
    final caixas = [
      Caixa(id: '1', nome: 'Refeições', palavras: ['Pizza', 'Sushi']),
      Caixa(id: '2', nome: 'Filmes', palavras: ['Ação', 'Comédia']),
    ];

    await repo.salvarTodas(caixas);

    final carregadas = await repo.carregarTodas();
    expect(carregadas.length, 2);
    expect(carregadas[0].nome, 'Refeições');
    expect(carregadas[0].palavras, ['Pizza', 'Sushi']);
    expect(carregadas[1].nome, 'Filmes');
    expect(carregadas[1].palavras, ['Ação', 'Comédia']);
  });

  test('sobrescreve os dados anteriores ao salvar de novo', () async {
    final repo = CaixaRepository();
    await repo.salvarTodas([
      Caixa(id: '1', nome: 'A', palavras: ['x']),
    ]);
    await repo.salvarTodas([
      Caixa(id: '2', nome: 'B', palavras: ['y']),
    ]);

    final carregadas = await repo.carregarTodas();
    expect(carregadas.length, 1);
    expect(carregadas.first.nome, 'B');
  });

  test('dados corrompidos retornam lista vazia', () async {
    SharedPreferences.setMockInitialValues({'caixas': '{{não é json'});
    final repo = CaixaRepository();

    expect(await repo.carregarTodas(), isEmpty);
  });

  test('json com formato errado retorna lista vazia', () async {
    SharedPreferences.setMockInitialValues({'caixas': '[1, 2, 3]'});
    final repo = CaixaRepository();

    expect(await repo.carregarTodas(), isEmpty);
  });
}