import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum K { hive }

class SecureStorage {
  static FlutterSecureStorage _instance = FlutterSecureStorage();

  static set instance(FlutterSecureStorage newInstance) {
    _instance = newInstance;
  }

  static Future<String?> read(K key) async {
    return await _instance.read(key: key.name);
  }

  static Future<Map<String, String>?> readAll() async {
    return await _instance.readAll();
  }

  static Future<void> write({required K key, required String? value}) async {
    await _instance.write(key: key.name, value: value);
  }

  static Future<void> writes(Map<K, String?> values) async {
    for (final entry in values.entries) {
      await _instance.write(key: entry.key.name, value: entry.value);
    }
  }

  static Future<void> delete(K key) async {
    await _instance.delete(key: key.name);
  }

  static Future<void> deletes(List<K> keys) async {
    for (final entry in keys) {
      await _instance.delete(key: entry.name);
    }
  }

  static Future<void> deleteAll() async {
    await _instance.deleteAll();
  }
}
