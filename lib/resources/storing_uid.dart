import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class UserSecureStorage{
  static final _storage = FlutterSecureStorage();
  static const _keyuid = "userId";
  static Future setUserId(String userId) async => await _storage.write(key: _keyuid, value: userId);
  static Future<String?> getUserId() async => await _storage.read(key: _keyuid);
}