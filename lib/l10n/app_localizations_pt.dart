// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get homeTitle => 'Roletas';

  @override
  String get newRoulette => 'Nova roleta';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get emptyState =>
      'Nenhuma roleta ainda.\nToque em \"Nova roleta\" para criar uma.';

  @override
  String wordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palavras',
      one: '$count palavra',
    );
    return '$_temp0';
  }

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteRouletteTitle => 'Excluir caixa?';

  @override
  String deleteRouletteMessage(String name) {
    return 'Tem certeza que deseja excluir \"$name\"? Esta ação não pode ser desfeita.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get formTitleNew => 'Nova roleta';

  @override
  String get formTitleEdit => 'Editar roleta';

  @override
  String get save => 'Salvar';

  @override
  String get nameLabel => 'Nome da roleta';

  @override
  String get wordsLabel => 'Palavras';

  @override
  String get add => 'Adicionar';

  @override
  String wordLabel(int index) {
    return 'Palavra $index';
  }

  @override
  String get deleteWordTooltip => 'Excluir palavra';

  @override
  String get deleteWordTitle => 'Excluir palavra?';

  @override
  String get deleteWordMessage => 'Esta palavra será removida da roleta.';

  @override
  String get errorNameEmpty => 'Informe um nome para a roleta.';

  @override
  String get errorWordEmpty => 'Adicione pelo menos uma palavra.';

  @override
  String get drawnMessage => 'Palavra sorteada!';

  @override
  String get noWords =>
      'Esta roleta não tem palavras.\nEdite-a para adicionar.';

  @override
  String get draw => 'Sortear';

  @override
  String get drawing => 'Sorteando…';

  @override
  String get shakeTip => 'Dica: agite o celular para sortear.';

  @override
  String get languageSection => 'Idioma';

  @override
  String get languageSub => 'Escolha o idioma do aplicativo.';

  @override
  String get langSystem => 'Padrão do sistema';

  @override
  String get freeCodeSection => 'Código livre';

  @override
  String get freeCodeText =>
      'Este é um projeto de código livre, licenciado sob a GNU GPL-3.0. As artes do aplicativo são de domínio público (CC0 1.0).';

  @override
  String get freeCodeGithub => 'Código no GitHub';

  @override
  String get freeCodeSite => 'Site';

  @override
  String get freeCodeContact => 'Contato';
}
