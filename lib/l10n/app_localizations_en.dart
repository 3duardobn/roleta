// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTitle => 'Roulettes';

  @override
  String get newRoulette => 'New roulette';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get emptyState =>
      'No roulettes yet.\nTap \"New roulette\" to create one.';

  @override
  String wordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '$count word',
    );
    return '$_temp0';
  }

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deleteRouletteTitle => 'Delete roulette?';

  @override
  String deleteRouletteMessage(String name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get formTitleNew => 'New roulette';

  @override
  String get formTitleEdit => 'Edit roulette';

  @override
  String get save => 'Save';

  @override
  String get nameLabel => 'Roulette name';

  @override
  String get wordsLabel => 'Words';

  @override
  String get add => 'Add';

  @override
  String wordLabel(int index) {
    return 'Word $index';
  }

  @override
  String get deleteWordTooltip => 'Delete word';

  @override
  String get deleteWordTitle => 'Delete word?';

  @override
  String get deleteWordMessage =>
      'This word will be removed from the roulette.';

  @override
  String get errorNameEmpty => 'Enter a name for the roulette.';

  @override
  String get errorWordEmpty => 'Add at least one word.';

  @override
  String get drawnMessage => 'Word drawn!';

  @override
  String get noWords => 'This roulette has no words.\nEdit it to add some.';

  @override
  String get draw => 'Draw';

  @override
  String get drawing => 'Drawing…';

  @override
  String get shakeTip => 'Tip: shake your phone to draw.';

  @override
  String get languageSection => 'Language';

  @override
  String get languageSub => 'Choose the app language.';

  @override
  String get langSystem => 'System default';

  @override
  String get licenseSection => 'License';

  @override
  String get licenseText =>
      'This is a free-code project, licensed under the GNU GPL-3.0. The app artworks are public domain (CC0 1.0).';

  @override
  String get licenseGithub => 'github.com/3duardobn/roleta';

  @override
  String get contactSection => 'Contact';

  @override
  String get contactSite => 'edbn.dev';

  @override
  String get contactEmail => 'edbn_dev@pm.me';
}
