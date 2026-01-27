import 'package:dartz/dartz.dart';
import 'package:price_alert/core/error/exception.dart';
import 'package:price_alert/features/auth/data/datasources/auth_locale_datasource.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('İnternet bağlantısı yok'));
    }

    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );

      await localDataSource.cacheUser(user);

      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        UnknownFailure('Beklenmeyen bir hata oluştu: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('İnternet bağlantısı yok'));
    }

    try {
      final user = await remoteDataSource.register(
        email: email,
        password: password,
        displayName: displayName,
      );

      await localDataSource.cacheUser(user);

      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        UnknownFailure('Beklenmeyen bir hata oluştu: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();

      await localDataSource.clearCache();

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(
        UnknownFailure('Çıkış yapılırken hata oluştu: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      if (await networkInfo.isConnected) {
        final user = await remoteDataSource.getCurrentUser();

        if (user != null) {
          await localDataSource.cacheUser(user);
          return Right(user.toEntity());
        }

        return const Right(null);
      } else {
        final cachedUser = await localDataSource.getCachedUser();

        if (cachedUser != null) {
          return Right(cachedUser.toEntity());
        }

        return const Right(null);
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(
        UnknownFailure('Kullanıcı bilgileri alınamadı: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      if (await networkInfo.isConnected) {
        final isAuth = await remoteDataSource.isAuthenticated();
        return Right(isAuth);
      } else {
        final isCached = await localDataSource.isUserCached();
        return Right(isCached);
      }
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('İnternet bağlantısı yok'));
    }

    try {
      final user = await remoteDataSource.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );

      await localDataSource.cacheUser(user);

      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        UnknownFailure('Profil güncellenirken hata oluştu: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('İnternet bağlantısı yok'));
    }

    try {
      await remoteDataSource.deleteAccount();

      await localDataSource.clearCache();

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        UnknownFailure('Hesap silinirken hata oluştu: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('İnternet bağlantısı yok'));
    }

    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        UnknownFailure('Şifre sıfırlama maili gönderilemedi: ${e.toString()}'),
      );
    }
  }
}
