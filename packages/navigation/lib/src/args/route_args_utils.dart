Map<String, dynamic>? normalizeExtraMap(Object? extra) {
  if (extra is Map<String, dynamic>) {
    return extra;
  }
  if (extra is Map) {
    final Map<String, dynamic> normalized = normalizeMap(extra);
    if (normalized.isNotEmpty) {
      return normalized;
    }
  }
  return null;
}

Map<String, dynamic> normalizeMap(Map<dynamic, dynamic> map) {
  final Map<String, dynamic> normalized = <String, dynamic>{};
  map.forEach((key, value) {
    if (key is String) {
      normalized[key] = normalizeValue(value);
    }
  });
  return normalized;
}

Object? normalizeValue(Object? value) {
  if (value is Map) {
    return normalizeMap(value);
  }
  if (value is List) {
    return value.map<Object?>(normalizeValue).toList();
  }
  return value;
}

int? toNullableInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

bool toBool(Object? value, {bool fallback = false}) {
  if (value is bool) {
    return value;
  }
  if (value is String) {
    return value.toLowerCase() == 'true';
  }
  return fallback;
}

List<int> toIntList(Object? value) {
  if (value is List) {
    return value.map<int?>(toNullableInt).whereType<int>().toList();
  }
  if (value is String && value.isNotEmpty) {
    return value.split(',').map<int?>(int.tryParse).whereType<int>().toList();
  }
  return const <int>[];
}

Map<String, String> compactQueryParameters(Map<String, String?> queryParameters) => Map<String, String>.fromEntries(
  queryParameters.entries
      .where((entry) => entry.value != null)
      .map((entry) => MapEntry<String, String>(entry.key, entry.value!)),
);
