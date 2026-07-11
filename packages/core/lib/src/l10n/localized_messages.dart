import 'package:core/src/utils/utils.dart';

final class LocalizedMessages {
  const LocalizedMessages._();

  static const LocalizedMessages instance = LocalizedMessages._();

  String _getText(String key, {String? locale}) {
    final String code = locale ?? defaultLocale;
    final String value = _languageMap[code]?[key] ?? key;
    return value;
  }

  String tr(String key, {String? locale}) => _getText(key, locale: locale);
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
  static const String transformTimeout = 'transformTimeout';
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
    'transformTimeout': 'The request transformation timed out. Please try again.',
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
    'transformTimeout': 'Время ожидания преобразования запроса истекло. Попробуйте снова.',
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
    'transformTimeout': 'So‘rovni o‘zgartirish vaqti tugadi. Yana urinib ko‘ring.',
  },
};
