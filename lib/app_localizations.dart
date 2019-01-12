import 'dart:async';

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Audio Recorder',
      'playResult': 'Play result',
      'stopResult': 'Stop',
      'record': 'Record',
      'errorRequiredPermissions': 'Please, grant all required permissions!',
      'errorRecording': 'An error occured while start recording!',
    },
    'ru': {
      'title': 'Диктофон',
      'playResult': 'Прослушать',
      'stopResult': 'Остановить',
      'record': 'Записать',
      'errorRequiredPermissions': 'Пожалуйста, дайте необходимые разрешения!',
      'errorRecording': 'Ошибка записи!',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get playResult {
    return _localizedValues[locale.languageCode]['playResult'];
  }

  String get stopResult {
    return _localizedValues[locale.languageCode]['stopResult'];
  }

  String get record {
    return _localizedValues[locale.languageCode]['record'];
  }

  String get errorRequiredPermissions {
    return _localizedValues[locale.languageCode]['errorRequiredPermissions'];
  }

  String get errorRecording {
    return _localizedValues[locale.languageCode]['errorRecording'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
