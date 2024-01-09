import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryPickerLocalizations {
  final Locale locale;

  CountryPickerLocalizations(this.locale);

  static CountryPickerLocalizations? of(BuildContext context) {
    return Localizations.of<CountryPickerLocalizations>(
      context,
      CountryPickerLocalizations,
    );
  }

  static const LocalizationsDelegate<CountryPickerLocalizations> delegate = _CountryPickerLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('packages/country_picker/src/i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String? translate(String? key) {
    return _localizedStrings[key!];
  }
}

class _CountryPickerLocalizationsDelegate extends LocalizationsDelegate<CountryPickerLocalizations> {
  const _CountryPickerLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      "af",
      "am",
      "ar",
      "az",
      "be",
      "bg",
      "bn",
      "bs",
      "ca",
      "cs",
      "da",
      "de",
      "el",
      "en",
      "es",
      "et",
      "fa",
      "fi",
      "fr",
      "gl",
      "ha",
      "he",
      "hi",
      "hr",
      "hu",
      "hy",
      "id",
      "is",
      "it",
      "ja",
      "ka",
      "kk",
      "km",
      "ko",
      "ku",
      "ky",
      "lt",
      "lv",
      "mk",
      "ml",
      "mn",
      "ms",
      "nb",
      "nl",
      "nn",
      "no",
      "pl",
      "ps",
      "pt",
      "ro",
      "ru",
      "sd",
      "sk",
      "sl",
      "so",
      "sq",
      "sr",
      "sv",
      "ta",
      "tg",
      "th",
      "tk",
      "tr",
      "tt",
      "uk",
      "ug",
      "ur",
      "uz",
      "vi",
      "zh",
    ].contains(locale.languageCode);
  }

  @override
  Future<CountryPickerLocalizations> load(Locale locale) async {
    CountryPickerLocalizations localizations = CountryPickerLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_CountryPickerLocalizationsDelegate old) => false;
}
