import 'package:dartz/dartz.dart';
import 'package:price_alert/core/error/failures.dart';
import 'package:price_alert/features/auth/domain/entities/user_entity.dart';
import 'package:price_alert/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}
