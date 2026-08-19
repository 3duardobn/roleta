import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Roulettes'**
  String get homeTitle;

  /// No description provided for @newRoulette.
  ///
  /// In en, this message translates to:
  /// **'New roulette'**
  String get newRoulette;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @emptyState.
  ///
  /// In en, this message translates to:
  /// **'No roulettes yet.\nTap \"New roulette\" to create one.'**
  String get emptyState;

  /// No description provided for @wordCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1 {{count} word} other {{count} words}}'**
  String wordCount(int count);

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteRouletteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete roulette?'**
  String get deleteRouletteTitle;

  /// No description provided for @deleteRouletteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String deleteRouletteMessage(String name);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @formTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New roulette'**
  String get formTitleNew;

  /// No description provided for @formTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit roulette'**
  String get formTitleEdit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Roulette name'**
  String get nameLabel;

  /// No description provided for @wordsLabel.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get wordsLabel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @wordLabel.
  ///
  /// In en, this message translates to:
  /// **'Word {index}'**
  String wordLabel(int index);

  /// No description provided for @deleteWordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete word'**
  String get deleteWordTooltip;

  /// No description provided for @deleteWordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete word?'**
  String get deleteWordTitle;

  /// No description provided for @deleteWordMessage.
  ///
  /// In en, this message translates to:
  /// **'This word will be removed from the roulette.'**
  String get deleteWordMessage;

  /// No description provided for @errorNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for the roulette.'**
  String get errorNameEmpty;

  /// No description provided for @errorWordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add at least one word.'**
  String get errorWordEmpty;

  /// No description provided for @drawnMessage.
  ///
  /// In en, this message translates to:
  /// **'Word drawn!'**
  String get drawnMessage;

  /// No description provided for @noWords.
  ///
  /// In en, this message translates to:
  /// **'This roulette has no words.\nEdit it to add some.'**
  String get noWords;

  /// No description provided for @draw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get draw;

  /// No description provided for @drawing.
  ///
  /// In en, this message translates to:
  /// **'Drawing…'**
  String get drawing;

  /// No description provided for @shakeTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: shake your phone to draw.'**
  String get shakeTip;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @languageSub.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language.'**
  String get languageSub;

  /// No description provided for @langSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get langSystem;

  /// No description provided for @freeCodeSection.
  ///
  /// In en, this message translates to:
  /// **'Free code'**
  String get freeCodeSection;

  /// No description provided for @freeCodeText.
  ///
  /// In en, this message translates to:
  /// **'This is a free-code project, licensed under the GNU GPL-3.0. The app artworks are public domain (CC0 1.0).'**
  String get freeCodeText;

  /// No description provided for @freeCodeGithub.
  ///
  /// In en, this message translates to:
  /// **'Code on GitHub'**
  String get freeCodeGithub;

  /// No description provided for @freeCodeSite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get freeCodeSite;

  /// No description provided for @freeCodeContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get freeCodeContact;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
