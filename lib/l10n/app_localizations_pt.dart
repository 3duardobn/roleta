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
  String get licenseSection => 'Licença';

  @override
  String get licenseText =>
      'Este é um projeto de código livre, licenciado sob a GNU GPL-3.0. As artes do aplicativo são de domínio público (CC0 1.0).';

  @override
  String get licenseGithub => 'github.com/3duardobn/roleta';

  @override
  String get contactSection => 'Contato';

  @override
  String get contactSub => 'Dúvidas, sugestões e relatos de bugs';

  @override
  String get contactSite => 'Site';

  @override
  String get contactEmail => 'Email';

  @override
  String get backupSection => 'Backup';

  @override
  String get backupSub =>
      'Salve ou compartilhe suas roletas como arquivo JSON.';

  @override
  String get export => 'Fazer backup';

  @override
  String get exportShare => 'Compartilhar';

  @override
  String get exportSave => 'Salvar arquivo';

  @override
  String get exportSubject => 'Backup do aplicativo Roleta';

  @override
  String get exportEmpty => 'Não há roletas para fazer backup.';

  @override
  String get exportSuccess => 'Backup salvo.';

  @override
  String get exportError => 'Não foi possível gerar o backup.';

  @override
  String get import => 'Restaurar backup';

  @override
  String get importTitle => 'Restaurar backup?';

  @override
  String importMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Este backup contém $count roletas.',
      one: 'Este backup contém 1 roleta.',
    );
    return '$_temp0 As roletas atuais serão substituídas. Continuar?';
  }

  @override
  String importSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Backup restaurado: $count roletas.',
      one: 'Backup restaurado: 1 roleta.',
    );
    return '$_temp0';
  }

  @override
  String get importError => 'Arquivo de backup inválido.';

  @override
  String get statsTitle => 'Estatísticas';

  @override
  String get statsEmpty =>
      'Nenhum sorteio registrado ainda.\nSorteie algumas palavras para ver as estatísticas.';

  @override
  String statsTotal(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total sorteios no total',
      one: '1 sorteio no total',
    );
    return '$_temp0';
  }

  @override
  String statsDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vezes',
      one: '1 vez',
    );
    return '$_temp0';
  }

  @override
  String get avoidRepeatLabel => 'Evitar repetir a última palavra';

  @override
  String get avoidRepeatSub =>
      'Não sorteia a mesma palavra duas vezes seguidas.';

  @override
  String get deactivateLabel => 'Remover palavra sorteada';

  @override
  String get deactivateSub =>
      'Cada sorteio remove a palavra da roleta, como um sorteio que vai diminuindo.';

  @override
  String get allWordsDrawn => 'Todas as palavras foram sorteadas. Recomeçando!';

  @override
  String remainingWords(int restante, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      restante,
      locale: localeName,
      other: 'Faltam $restante palavras de $total',
      one: 'Falta 1 palavra de $total',
    );
    return '$_temp0';
  }
}
