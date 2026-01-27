import 'package:firebase_auth/firebase_auth.dart';
import 'package:price_alert/core/error/exception.dart' show AuthException;
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> register({
    required String email,
    required String password,
    String? displayName,
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Future<bool> isAuthenticated();

  Future<UserModel> updateProfile({String? displayName, String? photoUrl});

  Future<void> deleteAccount();

  Future<void> sendPasswordResetEmail(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Giriş başarısız');
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Beklenmeyen bir hata oluştu: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Kayıt başarısız');
      }

      // DisplayName varsa güncelle
      if (displayName != null && displayName.isNotEmpty) {
        await credential.user!.updateDisplayName(displayName);
        await credential.user!.reload();
      }

      // Güncellenmiş user'ı al
      final updatedUser = firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw AuthException('Kullanıcı bilgileri alınamadı');
      }

      return UserModel.fromFirebaseUser(updatedUser);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Beklenmeyen bir hata oluştu: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Çıkış yapılırken hata oluştu: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) {
        return null;
      }

      // Son bilgileri al
      await user.reload();
      final updatedUser = firebaseAuth.currentUser;

      return updatedUser != null
          ? UserModel.fromFirebaseUser(updatedUser)
          : null;
    } catch (e) {
      throw AuthException('Kullanıcı bilgileri alınamadı: ${e.toString()}');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return firebaseAuth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) {
        throw AuthException('Kullanıcı oturumu bulunamadı');
      }

      // DisplayName güncelle
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }

      // PhotoUrl güncelle
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Kullanıcıyı yeniden yükle
      await user.reload();
      final updatedUser = firebaseAuth.currentUser;

      if (updatedUser == null) {
        throw AuthException('Profil güncellenemedi');
      }

      return UserModel.fromFirebaseUser(updatedUser);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Profil güncellenirken hata oluştu: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) {
        throw AuthException('Kullanıcı oturumu bulunamadı');
      }

      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Hesap silinirken hata oluştu: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleFirebaseAuthError(e));
    } catch (e) {
      throw AuthException(
        'Şifre sıfırlama maili gönderilemedi: ${e.toString()}',
      );
    }
  }

  // Firebase Auth hatalarını Türkçe mesajlara çevir
  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Bu e-posta adresiyle kayıtlı kullanıcı bulunamadı';
      case 'wrong-password':
        return 'Hatalı şifre';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanımda';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi';
      case 'weak-password':
        return 'Şifre çok zayıf (en az 6 karakter olmalı)';
      case 'user-disabled':
        return 'Bu hesap devre dışı bırakılmış';
      case 'too-many-requests':
        return 'Çok fazla deneme yaptınız. Lütfen daha sonra tekrar deneyin';
      case 'operation-not-allowed':
        return 'Bu işlem şu anda yapılamıyor';
      case 'requires-recent-login':
        return 'Bu işlem için yeniden giriş yapmanız gerekiyor';
      case 'network-request-failed':
        return 'İnternet bağlantısı hatası';
      default:
        return 'Bir hata oluştu: ${e.message ?? e.code}';
    }
  }
}
