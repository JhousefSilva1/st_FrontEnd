import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Preferences {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final keyAccessToken = 'accessToken';
  final keyEmail = 'email';
  final keyLastName = 'lastName';
  final keyName = 'name';
  final keyRefreshToken = 'refreshToken';
  final keyRole = 'role';

  Future<String> accessToken() async{
    String value = await _storage.read(key: keyAccessToken) ?? '';
    return value;
  }

  Future<String> email() async{
    String value = await _storage.read(key: keyEmail) ?? '';
    return value;
  }

  Future<String> lastName() async{
    String value = await _storage.read(key: keyLastName) ?? '';
    return value;
  }

  Future<String> name() async{
    String value = await _storage.read(key: keyName) ?? '';
    return value;
  }

  Future<String> refreshToken() async{
    String value = await _storage.read(key: keyRefreshToken) ?? '';
    return value;
  }

  Future<String> role() async{
    String value = await _storage.read(key: keyRole) ?? '';
    return value;
  }

  Future<void> setAccessToken(String value) async{
    await _storage.write(key: keyAccessToken, value: value);
  }

  Future<void> setEmail(String value) async{
    await _storage.write(key: keyEmail, value: value);
  }

  Future<void> setLastName(String value) async{
    await _storage.write(key: keyLastName, value: value);
  }

  Future<void> setName(String value) async{
    await _storage.write(key: keyName, value: value);
  }

  Future<void> setRefreshToken(String value) async{
    await _storage.write(key: keyRefreshToken, value: value);
  }

  Future<void> setRole(String value) async{
    await _storage.write(key: keyRole, value: value);
  }
}