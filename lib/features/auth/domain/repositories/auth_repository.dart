import 'package:dartz/dartz.dart';
import 'package:price_alert/core/error/failures.dart';
import 'package:price_alert/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    String? displayName,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, bool>> isAuthenticated();

  Future<Either<Failure, UserEntity>> updateProfile({
    String? displayName,
    String? photoUrl,
  });

  Future<Either<Failure, void>> deleteAccount();

  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
}
