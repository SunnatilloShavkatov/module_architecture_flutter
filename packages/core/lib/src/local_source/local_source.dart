import 'package:core/src/constants/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive_ce.dart' show Box;

abstract class LocalSource {
  const LocalSource();

  Future<bool> get hasProfile;

  String? get locale;

  Future<void> setLocale(String locale);

  ThemeMode get themeMode;

  Future<void> setThemeMode(ThemeMode mode);

  Future<String?> get accessToken;

  Future<void> setAccessToken(String accessToken);

  String get firstName;

  Future<void> setFirstName(String firstName);

  String get phone;

  Future<void> setPhone(String phone);

  int get userId;

  Future<void> setUserId(int userId);

  Future<void> setValue<T>({required String key, required T? value});

  T? getValue<T>({required String key});

  Future<void> removeValue({required String key});

  Future<void> clear();
}

final class LocalSourceImpl implements LocalSource {
  const LocalSourceImpl(this._systemBox, this._secureStorage);

  final Box<dynamic> _systemBox;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<bool> get hasProfile async => (await accessToken) != null;

  @override
  Future<void> setLocale(String locale) async {
    await _systemBox.put(StorageKeys.locale, locale);
  }

  @override
  String? get locale => _systemBox.get(StorageKeys.locale);

  @override
  ThemeMode get themeMode => switch (_systemBox.get(StorageKeys.themeMode)) {
    'system' => ThemeMode.system,
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await _systemBox.put(StorageKeys.themeMode, mode.name);
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    await _secureStorage.write(key: StorageKeys.accessToken, value: accessToken);
  }

  @override
  Future<String?> get accessToken => _secureStorage.read(key: StorageKeys.accessToken);

  @override
  Future<void> setFirstName(String firstName) async {
    await _systemBox.put(StorageKeys.firstname, firstName);
  }

  @override
  String get firstName => _systemBox.get(StorageKeys.firstname, defaultValue: '');

  @override
  Future<void> setPhone(String phone) async {
    await _systemBox.put(StorageKeys.phone, phone);
  }

  @override
  String get phone => _systemBox.get(StorageKeys.phone, defaultValue: '');

  @override
  Future<void> setUserId(int userId) async {
    await _systemBox.put(StorageKeys.userId, userId);
  }

  @override
  int get userId => _systemBox.get(StorageKeys.userId, defaultValue: 0);

  @override
  Future<void> setValue<T>({required String key, required T? value}) async {
    if (value != null) {
      await _systemBox.put(key, value);
    }
  }

  @override
  T? getValue<T>({required String key}) => _systemBox.get(key, defaultValue: null);

  @override
  Future<void> removeValue({required String key}) async {
    await _systemBox.delete(key);
  }

  Future<void> _deleteAllExceptKeepKeys() async {
    final keysToDelete = _systemBox.keys.where((k) => !StorageKeys.keep.contains(k)).toList();
    if (keysToDelete.isEmpty) {
      return;
    }
    await _systemBox.deleteAll(keysToDelete);
  }

  @override
  Future<void> clear() async {
    await Future.wait([_deleteAllExceptKeepKeys(), _secureStorage.delete(key: StorageKeys.accessToken)]);
  }
}
