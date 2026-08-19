// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get homeTitle => 'Ruletas';

  @override
  String get newRoulette => 'Nueva ruleta';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get emptyState =>
      'Aún no hay ruletas.\nToca en \"Nueva ruleta\" para crear una.';

  @override
  String wordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palabras',
      one: '$count palabra',
    );
    return '$_temp0';
  }

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteRouletteTitle => '¿Eliminar ruleta?';

  @override
  String deleteRouletteMessage(String name) {
    return '¿Seguro que quieres eliminar \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get formTitleNew => 'Nueva ruleta';

  @override
  String get formTitleEdit => 'Editar ruleta';

  @override
  String get save => 'Guardar';

  @override
  String get nameLabel => 'Nombre de la ruleta';

  @override
  String get wordsLabel => 'Palabras';

  @override
  String get add => 'Añadir';

  @override
  String wordLabel(int index) {
    return 'Palabra $index';
  }

  @override
  String get deleteWordTooltip => 'Eliminar palabra';

  @override
  String get deleteWordTitle => '¿Eliminar palabra?';

  @override
  String get deleteWordMessage => 'Esta palabra se eliminará de la ruleta.';

  @override
  String get errorNameEmpty => 'Indica un nombre para la ruleta.';

  @override
  String get errorWordEmpty => 'Añade al menos una palabra.';

  @override
  String get drawnMessage => '¡Palabra sorteada!';

  @override
  String get noWords => 'Esta ruleta no tiene palabras.\nEdítala para añadir.';

  @override
  String get draw => 'Sortear';

  @override
  String get drawing => 'Sorteando…';

  @override
  String get shakeTip => 'Consejo: agita el teléfono para sortear.';

  @override
  String get languageSection => 'Idioma';

  @override
  String get languageSub => 'Elige el idioma de la aplicación.';

  @override
  String get langSystem => 'Predeterminado del sistema';

  @override
  String get licenseSection => 'Licencia';

  @override
  String get licenseText =>
      'Este es un proyecto de código libre, con licencia GNU GPL-3.0. Las artes de la aplicación son de dominio público (CC0 1.0).';

  @override
  String get licenseGithub => 'github.com/3duardobn/roleta';

  @override
  String get contactSection => 'Contacto';

  @override
  String get contactSite => 'edbn.dev';

  @override
  String get contactEmail => 'edbn_dev@pm.me';
}
