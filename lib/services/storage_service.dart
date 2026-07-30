import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk menangani penyimpanan data lokal menggunakan SharedPreferences.
/// Mendukung penyimpanan objek dalam bentuk JSON (Map/List) maupun tipe primitif.
class StorageService {
  StorageService._internal();
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  SharedPreferences? _prefs;

  /// Wajib dipanggil sekali di awal (misalnya di main()) sebelum service dipakai.
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _prefsInstance {
    if (_prefs == null) {
      throw StateError(
        'StorageService belum diinisialisasi. Panggil StorageService().init() terlebih dahulu.',
      );
    }
    return _prefs!;
  }

  // ---------- Penyimpanan objek/JSON ----------

  /// Menyimpan objek (Map atau List) sebagai JSON string.
  Future<bool> saveObject(String key, dynamic value) async {
    final jsonString = jsonEncode(value);
    return await _prefsInstance.setString(key, jsonString);
  }

  /// Mengambil objek yang tersimpan sebagai Map<String, dynamic>.
  /// Mengembalikan null jika key tidak ditemukan atau gagal parse.
  Map<String, dynamic>? getObject(String key) {
    final jsonString = _prefsInstance.getString(key);
    if (jsonString == null) return null;
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Mengambil objek yang tersimpan sebagai List<dynamic>.
  List<dynamic>? getList(String key) {
    final jsonString = _prefsInstance.getString(key);
    if (jsonString == null) return null;
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List<dynamic>) return decoded;
      return null;
    } catch (e) {
      return null;
    }
  }

  // ---------- Tipe primitif ----------

  Future<bool> saveString(String key, String value) =>
      _prefsInstance.setString(key, value);

  String? getString(String key) => _prefsInstance.getString(key);

  Future<bool> saveInt(String key, int value) =>
      _prefsInstance.setInt(key, value);

  int? getInt(String key) => _prefsInstance.getInt(key);

  Future<bool> saveBool(String key, bool value) =>
      _prefsInstance.setBool(key, value);

  bool? getBool(String key) => _prefsInstance.getBool(key);

  Future<bool> saveDouble(String key, double value) =>
      _prefsInstance.setDouble(key, value);

  double? getDouble(String key) => _prefsInstance.getDouble(key);

  // ---------- Utilitas ----------

  /// Menghapus satu key.
  Future<bool> remove(String key) => _prefsInstance.remove(key);

  /// Mengecek apakah key ada.
  bool containsKey(String key) => _prefsInstance.containsKey(key);

  /// Menghapus semua data yang tersimpan.
  Future<bool> clearAll() => _prefsInstance.clear();
}