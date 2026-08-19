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
  String get contactSub => 'Preguntas, sugerencias e informes de errores';

  @override
  String get contactSite => 'Sitio web';

  @override
  String get contactEmail => 'Correo';

  @override
  String get backupSection => 'Copia de seguridad';

  @override
  String get backupSub => 'Guarda o comparte tus ruletas como archivo JSON.';

  @override
  String get export => 'Hacer copia de seguridad';

  @override
  String get exportShare => 'Compartir';

  @override
  String get exportSave => 'Guardar archivo';

  @override
  String get exportSubject => 'Copia de seguridad de la app Roleta';

  @override
  String get exportEmpty => 'No hay ruletas para respaldar.';

  @override
  String get exportSuccess => 'Copia guardada.';

  @override
  String get exportError => 'No se pudo generar la copia de seguridad.';

  @override
  String get import => 'Restaurar copia de seguridad';

  @override
  String get importTitle => '¿Restaurar copia de seguridad?';

  @override
  String importMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Esta copia contiene $count ruletas.',
      one: 'Esta copia contiene 1 ruleta.',
    );
    return '$_temp0 Las ruletas actuales serán reemplazadas. ¿Continuar?';
  }

  @override
  String importSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Copia restaurada: $count ruletas.',
      one: 'Copia restaurada: 1 ruleta.',
    );
    return '$_temp0';
  }

  @override
  String get importError => 'Archivo de copia no válido.';

  @override
  String get statsTitle => 'Estadísticas';

  @override
  String get statsEmpty =>
      'Aún no hay sorteos registrados.\nSorteá algunas palabras para ver las estadísticas.';

  @override
  String statsTotal(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total sorteos en total',
      one: '1 sorteo en total',
    );
    return '$_temp0';
  }

  @override
  String statsDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veces',
      one: '1 vez',
    );
    return '$_temp0';
  }

  @override
  String get avoidRepeatLabel => 'Evitar repetir la última palabra';

  @override
  String get avoidRepeatSub => 'No sortea la misma palabra dos veces seguidas.';

  @override
  String get deactivateLabel => 'Quitar palabra sorteada';

  @override
  String get deactivateSub =>
      'Cada sorteo quita la palabra de la ruleta, como un sorteo que va disminuyendo.';

  @override
  String get allWordsDrawn =>
      '¡Todas las palabras fueron sorteadas! Recomenzando.';

  @override
  String remainingWords(int restante, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      restante,
      locale: localeName,
      other: 'Quedan $restante palabras de $total',
      one: 'Queda 1 palabra de $total',
    );
    return '$_temp0';
  }
}
