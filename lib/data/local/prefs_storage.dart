import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PrefsStorage {
  final SharedPreferences _prefs;

  PrefsStorage(this._prefs);

  static Future<PrefsStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PrefsStorage(prefs);
  }

  Map<String, dynamic>? readJsonObject(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  List<dynamic>? readJsonArray(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> writeJson(String key, Object value) async {
    await _prefs.setString(key, jsonEncode(value));
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clearAll(Iterable<String> keys) async {
    for (final k in keys) {
      await _prefs.remove(k);
    }
  }
}
