import 'package:dartz/dartz.dart';
import 'package:price_alert/core/error/failures.dart';
import 'package:price_alert/features/auth/domain/entities/user_entity.dart';
import 'package:price_alert/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
}
