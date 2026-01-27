import 'package:hive_flutter/hive_flutter.dart';
import 'package:price_alert/core/error/exception.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<bool> isUserCached();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<dynamic> userBox;

  AuthLocalDataSourceImpl({required this.userBox});

  static const String _userKey = 'cached_user';

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await userBox.put(_userKey, user.toJson());
    } catch (e) {
      throw CacheException(
        'Kullanıcı bilgileri kaydedilemedi: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userData = userBox.get(_userKey);

      if (userData == null) {
        return null;
      }

      return UserModel.fromJson(Map<String, dynamic>.from(userData));
    } catch (e) {
      throw CacheException('Kullanıcı bilgileri alınamadı: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await userBox.delete(_userKey);
    } catch (e) {
      throw CacheException('Cache temizlenemedi: ${e.toString()}');
    }
  }

  @override
  Future<bool> isUserCached() async {
    try {
      return userBox.containsKey(_userKey);
    } catch (e) {
      return false;
    }
  }
}
