import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static StorageUtil _storageUtil;
  static SharedPreferences _preferences;

  static Future<StorageUtil> getInstance() async {
    if (_storageUtil == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = StorageUtil._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }

  StorageUtil._();
  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static dynamic getFromDisk(String key) {
    var value  = _preferences.get(key);
    print('(TRACE) LocalStorageService: _getFromDisk. key: $key value: $value');
    return value;
  }

  static Future<void> saveToDisk<T>(String key, T content){
    print('(TRACE) LocalStorageService: _saveToDisk. key: $key value: $content');
    if (_preferences == null) return null;

    if(content is String) {
      _preferences.setString(key, content);
    }
    if(content is bool) {
      _preferences.setBool(key, content);
    }
    if(content is int) {
      _preferences.setInt(key, content);
    }
    if(content is double) {
      _preferences.setDouble(key, content);
    }
    if(content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }

}
