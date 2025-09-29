import 'package:core/src/utils/utils.dart';

final class LocalizedMessages {
  const LocalizedMessages._();

  static const LocalizedMessages instance = LocalizedMessages._();

  String _getText(String key, {String? locale}) {
    final String code = locale ?? defaultLocale;
    final String value = _languageMap[code]?[key] ?? key;
    return value;
  }

  String tr(String key, {required String? locale}) => _getText(key, locale: locale);
}

final class LocalizationKeys {
  const LocalizationKeys._();

  static const String connectionError = 'connectionError';
  static const String connectionTimeout = 'connectionTimeout';
  static const String sendTimeout = 'sendTimeout';
  static const String receiveTimeout = 'receiveTimeout';
  static const String tokenExpired = 'tokenExpired';
  static const String notFound = 'notFound';
  static const String serverError = 'serverError';
  static const String somethingWrong = 'somethingWrong';
  static const String badCertificate = 'badCertificate';
  static const String requestEntityTooLarge = 'requestEntityTooLarge';
  static const String canceled = 'canceled';
  static const String typeError = 'typeError';
  static const String formatException = 'formatException';
  static const String unknownError = 'unknownError';
  static const String notAccessToken = 'notAccessToken';
}

const Map<String, Map<String, String>> _languageMap = {
  'en': {
    'connectionError': 'There was an error connecting to the internet.',
    'connectionTimeout': 'Connection timed out. Please try again.',
    'sendTimeout': 'Request sending timed out. Please check your internet connection.',
    'receiveTimeout': 'Response receiving timed out. Please try again later.',
    'tokenExpired': 'Session expired. Please log in again.',
    'notFound': 'Requested information was not found.',
    'serverError': 'A server error occurred. Please try again later.',
    'somethingWrong': 'An unknown error occurred. Please try again.',
    'badCertificate': 'Invalid security certificate.',
    'requestEntityTooLarge': 'The request size is too large.',
    'canceled': 'Request was canceled.',
    'typeError': 'Invalid data type.',
    'formatException': 'Invalid data format.',
    'unknownError': 'An unknown error occurred.',
    'notAccessToken': 'Your session has expired, please log in again.',
    'error_no_match': 'No speech detected. Try again.',
    'error_client': 'Client error occurred. Please try again.',
    'error_speech_timeout': 'No speech detected. Try again.',
    'error_network': 'Network error occurred. Please check your connection.',
    'error_busy': 'The speech recognition service is busy. Please try again later.',
    'error_language_unavailable': 'The selected language is not available. Please choose another language.',
    'error_speech_recognizer_connection_interrupted':
        'The connection to the speech recognition service was interrupted. Please try again.',
    'error_permission': 'Microphone permission is denied. Please enable it in settings.',
    'error_assets_not_installed': 'Speech recognition assets are not installed. Please install them and try again.',
    'error_listen_failed': 'The microphone failed to start. Please try again.',
    'error_retry': 'An error occurred. Please try again.',
    'error_unknown (209)': 'An unknown error occurred. Please try again.',
    'error_network_timeout': 'The network connection timed out. Please check your connection and try again.',
  },
  'ru': {
    'connectionError': 'Ошибка подключения к интернету.',
    'connectionTimeout': 'Время ожидания подключения истекло. Попробуйте снова.',
    'sendTimeout': 'Время отправки запроса истекло. Проверьте ваше интернет-соединение.',
    'receiveTimeout': 'Время ожидания ответа истекло. Попробуйте позже.',
    'tokenExpired': 'Срок действия сеанса истек. Пожалуйста, войдите снова.',
    'notFound': 'Запрашиваемая информация не найдена.',
    'serverError': 'Ошибка на сервере. Попробуйте позже.',
    'somethingWrong': 'Произошла неизвестная ошибка. Попробуйте снова.',
    'badCertificate': 'Неверный сертификат безопасности.',
    'requestEntityTooLarge': 'Запрос слишком большой.',
    'canceled': 'Запрос отменен.',
    'typeError': 'Неверный тип данных.',
    'unknownError': 'Неизвестная ошибка.',
    'formatException': 'Неверный формат данных.',
    'notAccessToken': 'Срок действия входа истёк, войдите снова.',
    'error_no_match': 'Ничего не распознано. Повторите.',
    'error_client': 'Произошла ошибка клиента. Попробуйте снова.',
    'error_speech_timeout': 'Ничего не распознано. Повторите.',
    'error_network': 'Произошла сетевая ошибка. Проверьте ваше соединение.',
    'error_busy': 'Служба распознавания речи занята. Попробуйте позже.',
    'error_language_unavailable': 'Выбранный язык недоступен. Пожалуйста, выберите другой язык.',
    'error_speech_recognizer_connection_interrupted':
        'Соединение со службой распознавания речи было прервано. Попробуйте снова.',
    'error_permission': 'Разрешение на использование микрофона запрещено. Пожалуйста, включите его в настройках.',
    'error_assets_not_installed':
        'Ресурсы для распознавания речи не установлены. Пожалуйста, установите их и попробуйте снова.',
    'error_listen_failed': 'Микрофон не удалось запустить. Попробуйте снова.',
    'error_retry': 'Произошла ошибка. Попробуйте снова.',
    'error_unknown (209)': 'Произошла неизвестная ошибка. Попробуйте снова.',
    'error_network_timeout':
        'Время ожидания сетевого соединения истекло. Проверьте ваше соединение и попробуйте снова.',
  },
  'uz': {
    'connectionError': 'Internetga ulanishda muammo yuz berdi.',
    'connectionTimeout': 'Ulanish vaqti tugadi. Qayta urinib ko‘ring.',
    'sendTimeout': 'So‘rovni yuborish vaqti tugadi. Internet aloqangizni tekshiring.',
    'receiveTimeout': 'Javobni olish vaqti tugadi. Keyinroq qayta urinib ko‘ring.',
    'tokenExpired': 'Sessiya muddati tugagan. Qayta tizimga kiring.',
    'notFound': 'So‘ralgan ma’lumot topilmadi.',
    'serverError': 'Server xatosi yuz berdi. Keyinroq qayta urinib ko‘ring.',
    'somethingWrong': 'Noma’lum xatolik yuz berdi. Qayta urinib ko‘ring.',
    'badCertificate': 'Xavfsizlik sertifikati noto‘g‘ri.',
    'requestEntityTooLarge': 'So‘rov hajmi juda katta.',
    'canceled': 'So‘rov bekor qilindi.',
    'typeError': 'Ma’lumot turi noto‘g‘ri.',
    'unknownError': 'Noma’lum xato yuz berdi.',
    'formatException': 'Ma’lumot formati noto‘g‘ri.',
    'notAccessToken': 'Kirish muddati tugagan, qaytadan kiring.',
    'error_no_match': 'Hech narsa eshitilmadi. Yana gapirib ko‘ring.',
    'error_client': 'Mijoz xatosi yuz berdi. Yana urinib ko‘ring.',
    'error_speech_timeout': 'Hech narsa eshitilmadi. Yana gapirib ko‘ring.',
    'error_network': 'Tarmoq xatosi yuz berdi. Aloqangizni tekshiring.',
    'error_busy': 'Nutqni tanish xizmati band. Keyinroq qayta urinib ko‘ring.',
    'error_language_unavailable': 'Tanlangan til mavjud emas. Iltimos, boshqa tilni tanlang.',
    'error_speech_recognizer_connection_interrupted': 'Nutqni tanish xizmati bilan aloqa uzildi. Yana urinib ko‘ring.',
    'error_permission': 'Mikrofon uchun ruxsat berilmagan. Iltimos, uni sozlamalarda yoqing.',
    'error_assets_not_installed':
        'Nutqni tanish resurslari o‘rnatilmagan. Iltimos, ularni o‘rnating va yana urinib ko‘ring.',
    'error_listen_failed': 'Mikrofon ishga tushmadi. Yana urinib ko‘ring.',
    'error_retry': 'Xatolik yuz berdi. Yana urinib ko‘ring.',
    'error_unknown (209)': 'Noma’lum xatolik yuz berdi. Yana urinib ko‘ring.',
    'error_network_timeout': 'Tarmoq ulanishi vaqti tugadi. Aloqangizni tekshiring va yana urinib ko‘ring.',
  },
};
