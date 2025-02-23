import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['pt', 'en', 'es'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? ptText = '',
    String? enText = '',
    String? esText = '',
  }) =>
      [ptText, enText, esText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    'vcqi6g9r': {
      'pt': 'Âncora',
      'en': 'Anchor',
      'es': 'Ancla',
    },
    'ei36on5v': {
      'pt': '30 M',
      'en': '30 M',
      'es': '30M',
    },
    'tfjkq7qs': {
      'pt': 'Motor',
      'en': 'Engine',
      'es': 'Motor',
    },
    'huvsvnas': {
      'pt': '30.0 ºC',
      'en': '30.0 ºC',
      'es': '30,0ºC',
    },
    'icupkutz': {
      'pt': 'Tensão',
      'en': 'Voltage',
      'es': 'Voltaje',
    },
    'lkvqo04q': {
      'pt': '48.0 V',
      'en': '48.0 V',
      'es': '48,0 V',
    },
    '4z6klaj3': {
      'pt': 'Control',
      'en': 'Control',
      'es': 'Control',
    },
    'wrarzam8': {
      'pt': '48.0 ºC',
      'en': '48.0 ºC',
      'es': '48,0ºC',
    },
    'y840d2q7': {
      'pt': 'MENSAGEM EXTRA',
      'en': 'EXTRA MESSAGE',
      'es': 'MENSAJE ADICIONAL',
    },
    'zcmithhn': {
      'pt': 'BOTÃO 1',
      'en': 'BUTTON 1',
      'es': 'BOTÓN 1',
    },
    'h0kdz7rn': {
      'pt': 'NOTÃO 2',
      'en': 'NOTE 2',
      'es': 'NOTACIÓN 2',
    },
    'hplpl5m2': {
      'pt': 'BOTÃO 3',
      'en': 'BUTTON 3',
      'es': 'BOTÓN 3',
    },
    'l9zi1d22': {
      'pt': 'Home',
      'en': '',
      'es': '',
    },
  },
  // Settings
  {
    'mgjyvhj9': {
      'pt': 'Conta',
      'en': 'Account',
      'es': 'Cuenta',
    },
    '0gxa388i': {
      'pt': 'Perfil',
      'en': 'Profile',
      'es': 'Perfil',
    },
    'wvdcpejy': {
      'pt': 'Entrar / Criar',
      'en': 'Login / Create',
      'es': 'Iniciar sesión/Crear',
    },
    '4gcw9gfi': {
      'pt': 'Sair',
      'en': 'To go out',
      'es': 'para salir',
    },
    '7ktye1l7': {
      'pt': 'Conta',
      'en': 'Account',
      'es': 'Cuenta',
    },
    'buw19k5x': {
      'pt': 'Localização',
      'en': 'Location',
      'es': 'Ubicación',
    },
    '1xyfy9ox': {
      'pt': 'Bluetooth',
      'en': 'Bluetooth',
      'es': 'bluetooth',
    },
    'gj2yt8p1': {
      'pt': 'Definições',
      'en': 'Definitions',
      'es': 'Definiciones',
    },
    'dvvlgymg': {
      'pt': 'Unidade',
      'en': 'Unit',
      'es': 'Unidad',
    },
    '9riv3pk5': {
      'pt': 'Km/h',
      'en': 'Km/h',
      'es': 'kilómetros por hora',
    },
    'v1g3gq7o': {
      'pt': 'Metros',
      'en': 'Meters',
      'es': 'Metros',
    },
    'mg4vlgv6': {
      'pt': 'Centrimetos',
      'en': 'Centrimeters',
      'es': 'centrimidas',
    },
    'scrdsugf': {
      'pt': 'Km/h',
      'en': 'Km/h',
      'es': 'kilómetros por hora',
    },
    'on4uz4ai': {
      'pt': 'Search...',
      'en': 'Search...',
      'es': 'Buscar...',
    },
    'q4xal93j': {
      'pt': 'Região',
      'en': 'Region',
      'es': 'Región',
    },
    'n7sw8qti': {
      'pt': 'Km/h',
      'en': 'Km/h',
      'es': 'kilómetros por hora',
    },
    'lhkfbvls': {
      'pt': 'Metros',
      'en': 'Meters',
      'es': 'Metros',
    },
    'o0gatpiv': {
      'pt': 'Centrimetos',
      'en': 'Centrimeters',
      'es': 'centrimidas',
    },
    '8jtjtp6t': {
      'pt': 'Km/h',
      'en': 'Km/h',
      'es': 'kilómetros por hora',
    },
    'zhy7vmfx': {
      'pt': 'Search...',
      'en': 'Search...',
      'es': 'Buscar...',
    },
    'hbpj78uo': {
      'pt': 'Suporte',
      'en': 'Support',
      'es': 'Apoyo',
    },
    'ft4nw8o4': {
      'pt': 'Ajuda',
      'en': 'Help',
      'es': 'Ayuda',
    },
    'njgj28fj': {
      'pt': 'Email',
      'en': 'E-mail',
      'es': 'Correo electrónico',
    },
    't7ixcoi9': {
      'pt': 'Sobre o app',
      'en': 'About the app',
      'es': 'Acerca de la aplicación',
    },
    'g5renpq2': {
      'pt': '23.09.0',
      'en': '23.09.0',
      'es': '23.09.0',
    },
    '844c705g': {
      'pt': 'Políticas de Privacidade',
      'en': 'Privacy Policies',
      'es': 'Políticas de privacidad',
    },
    'qw4tztry': {
      'pt': 'Home',
      'en': '',
      'es': '',
    },
  },
  // Bussola
  {
    'mw14nw9t': {
      'pt': 'Page Title',
      'en': 'Page Title',
      'es': 'Título de la página',
    },
    '77913xkf': {
      'pt': 'Home',
      'en': '',
      'es': '',
    },
  },
  // Miscellaneous
  {
    'jvoiq8pd': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'zkgnryba': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'agfzxhgn': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'e45zaw1d': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'vcoj4123': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'l1r96p94': {
      'pt': '',
      'en': '',
      'es': '',
    },
    '3barlbqy': {
      'pt': '',
      'en': '',
      'es': '',
    },
    '3n95bfrg': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'scvrzfpf': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'z5ekrope': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'if9s3xw4': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'bijepvw0': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'o5mheywl': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'x5cu1s6v': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'zwjo612g': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'qgxogp7v': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'vqtberdk': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'sze60waa': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'jnjtk0ld': {
      'pt': '',
      'en': '',
      'es': '',
    },
    '7y4xery2': {
      'pt': '',
      'en': '',
      'es': '',
    },
    '51x91xic': {
      'pt': '',
      'en': '',
      'es': '',
    },
    '9dei9bbz': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'h5k1zzo6': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'r5b2or5v': {
      'pt': '',
      'en': '',
      'es': '',
    },
    'jz2pqf75': {
      'pt': '',
      'en': '',
      'es': '',
    },
  },
].reduce((a, b) => a..addAll(b));
